# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Commands::Say do
  subject(:command) { described_class.new(player:, args:) }

  let(:player) { instance_double(Mud::Player, puts: nil, name: 'Alice') }
  let(:server) { instance_double(Mud::Server, broadcast: nil) }
  let(:args) { 'hello world' }

  before { allow(Mud::Server).to receive(:instance).and_return(server) }

  it 'inherits from Base' do
    expect(described_class).to be < Mud::Commands::Base
  end

  describe '#perform' do
    it 'sends formatted message to player' do
      expect(player).to receive(:puts).with("&cYou say, 'hello world'")
      command.perform
    end

    it 'broadcasts to other players' do
      expect(server).to receive(:broadcast).with("&cAlice says, 'hello world'", except: player)
      command.perform
    end

    context 'with color code in input' do
      let(:args) { '&rhello' }

      it 'escapes color codes for player' do
        expect(player).to receive(:puts).with("&cYou say, '&&rhello'")
        command.perform
      end

      it 'escapes color codes for broadcast' do
        expect(server).to receive(:broadcast).with("&cAlice says, '&&rhello'", except: player)
        command.perform
      end
    end
  end
end
