# frozen_string_literal: true

RSpec.describe Mud::Commands::Base do
  let(:player) { instance_double(Mud::Player, puts: nil) }

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
  end

  describe '.execute' do
    let(:test_class) { Class.new(described_class) { def perform(args) = player.puts(args) } }

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
    it 'calls perform with args' do
      test_class = Class.new(described_class) { def perform(args) = player.puts(args) }
      test_class.new(player:).execute(args: 'test')
      expect(player).to have_received(:puts).with('test')
    end
  end
end
