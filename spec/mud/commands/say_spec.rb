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

  describe '#execute' do
    it 'sends formatted message to player' do
      command.execute
      expect(player).to have_received(:puts).with("You say, 'hello world'")
    end

    it 'broadcasts to other players' do
      command.execute
      expect(server).to have_received(:broadcast).with("Alice says, 'hello world'", except: player)
    end
  end
end
