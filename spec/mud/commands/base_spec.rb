# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Commands::Base do
  subject(:command) { described_class.new(player:, args:) }

  let(:client) { instance_double(Mud::Network::Client, puts: nil, gets: nil, close: nil) }
  let(:player) { Mud::Player.new(name: 'Test', client:) }
  let(:args) { 'some arguments' }

  describe '.command' do
    let(:test_class) { Class.new(described_class) }

    it 'registers command with registry' do
      expect(Mud::CommandRegistry).to receive(:register).with(test_class, :look, aliases: %i[l])
      test_class.command(:look, aliases: %i[l])
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

    it 'instantiates and executes' do
      expect(player).to receive(:puts).with('performed')
      test_class.execute(player:, args:)
    end
  end

  describe '#execute' do
    it 'calls perform' do
      expect(command).to receive(:perform)
      command.execute
    end
  end

  describe '#perform' do
    it 'raises NotImplementedError' do
      expect { command.perform }.to raise_error(NotImplementedError)
    end
  end
end
