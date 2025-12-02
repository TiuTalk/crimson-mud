# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Commands::Base do
  subject(:command) { described_class.new(player:, args:) }

  let(:player) { instance_double(Mud::Player) }
  let(:args) { 'some arguments' }

  describe '.command' do
    let(:test_class) { Class.new(described_class) }

    before { allow(Mud::CommandRegistry).to receive(:register) }

    it 'registers command with registry' do
      test_class.command(:look, aliases: %i[l])
      expect(Mud::CommandRegistry).to have_received(:register).with(test_class, :look, aliases: %i[l])
    end
  end

  describe '.execute' do
    let(:test_class) do
      Class.new(described_class) do
        def perform
          player.puts('performed')
        end
      end
    end

    before { allow(player).to receive(:puts) }

    it 'instantiates and executes' do
      test_class.execute(player:, args:)
      expect(player).to have_received(:puts).with('performed')
    end
  end

  describe '#execute' do
    it 'calls perform' do
      allow(command).to receive(:perform)
      command.execute
      expect(command).to have_received(:perform)
    end
  end

  describe '#perform' do
    it 'raises NotImplementedError' do
      expect { command.perform }.to raise_error(NotImplementedError)
    end
  end
end
