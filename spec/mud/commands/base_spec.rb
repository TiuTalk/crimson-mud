# frozen_string_literal: true

RSpec.describe Mud::Commands::Base do
  let(:player) { instance_double(Mud::Player, puts: nil, name: 'Alice') }
  let(:logger) { instance_double(Logger, debug: nil) }

  before { allow(Mud).to receive(:logger).and_return(logger) }

  describe '.command' do
    after { Mud::Commands::Registry.unregister(:test) }

    it 'registers command with Registry' do
      stub_const('TestCommand', Class.new(described_class) { command :test })
      expect(Mud::Commands::Registry.lookup('test')).to eq(TestCommand)
    end

    it 'registers multiple keywords' do
      stub_const('MultiCommand', Class.new(described_class) { command :test, :test2 })
      expect(Mud::Commands::Registry.lookup('test')).to eq(MultiCommand)
      expect(Mud::Commands::Registry.lookup('test2')).to eq(MultiCommand)
    ensure
      Mud::Commands::Registry.unregister(:test2)
    end

    it 'stores usage when provided' do
      stub_const('UsageCommand', Class.new(described_class) { command :test, usage: 'test <arg>' })
      expect(UsageCommand.usage).to eq('test <arg>')
    end

    it 'stores min_args when provided' do
      stub_const('ArgsCommand', Class.new(described_class) { command :test, args: 2 })
      expect(ArgsCommand.min_args).to eq(2)
    end
  end

  describe '.validate' do
    it 'registers validation methods' do
      stub_const('ValidateCommand', Class.new(described_class) do
        validate :check_one
        validate :check_two
      end)
      expect(ValidateCommand.validations).to eq(%i[check_one check_two])
    end

    it 'inherits empty validations by default' do
      stub_const('NoValidateCommand', Class.new(described_class))
      expect(NoValidateCommand.validations).to eq([])
    end
  end

  describe '.execute' do
    let(:test_class) { Class.new(described_class) { def perform = player.puts(args.join(' ')) } }

    it 'instantiates and calls instance execute' do
      test_class.execute(player, 'hello')
      expect(player).to have_received(:puts).with('hello')
    end

    it 'defaults args to empty string' do
      test_class.execute(player)
      expect(player).to have_received(:puts).with('')
    end
  end

  describe '#execute' do
    it 'logs command execution' do
      test_class = Class.new(described_class) { def perform = nil }
      stub_const('TestCommand', test_class)
      TestCommand.new(player:).execute
      expect(logger).to have_received(:debug).with('Alice executing: TestCommand')
    end

    context 'with usage and insufficient args' do
      it 'shows usage when fewer args than min_args' do
        test_class = Class.new(described_class) do
          command :test, args: 2, usage: 'test <a> <b>'
          def perform = player.puts('performed')
        end
        test_class.new(player:, args: 'one').execute
        expect(player).to have_received(:puts).with('test <a> <b>')
        expect(player).not_to have_received(:puts).with('performed')
      end

      it 'proceeds when enough args provided' do
        test_class = Class.new(described_class) do
          command :test, args: 2, usage: 'test <a> <b>'
          def perform = player.puts('performed')
        end
        test_class.new(player:, args: 'one two').execute
        expect(player).to have_received(:puts).with('performed')
      end
    end

    context 'with validations' do
      it 'halts on validation failure and shows error' do
        test_class = Class.new(described_class) do
          validate :always_fail
          def perform = player.puts('performed')
          def always_fail = 'Validation failed'
        end
        test_class.new(player:, args: 'test').execute
        expect(player).to have_received(:puts).with('Validation failed')
        expect(player).not_to have_received(:puts).with('performed')
      end

      it 'continues when validation returns nil' do
        test_class = Class.new(described_class) do
          validate :always_pass
          def perform = player.puts('performed')
          def always_pass = nil
        end
        test_class.new(player:, args: 'test').execute
        expect(player).to have_received(:puts).with('performed')
      end
    end
  end
end
