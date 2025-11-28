# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Player do
  subject(:player) { described_class.new(name: 'Alice', client:) }

  let(:client) { instance_double(Mud::Network::Client, puts: nil, gets: nil, close: nil, ip_address: '192.168.1.100') }

  describe '#name' do
    it 'returns name' do
      expect(player.name).to eq('Alice')
    end
  end

  describe '#puts' do
    it 'delegates to client' do
      player.puts('hello')

      expect(client).to have_received(:puts).with('hello')
    end
  end

  describe '#gets' do
    it 'delegates to client' do
      allow(client).to receive(:gets).and_return("hello\n")

      expect(player.gets).to eq("hello\n")
    end
  end

  describe '#disconnect' do
    it 'closes client' do
      player.disconnect

      expect(client).to have_received(:close)
    end
  end

  describe '#ip_address' do
    it 'delegates to client' do
      expect(player.ip_address).to eq('192.168.1.100')
    end
  end

  describe '#say' do
    let(:server) { instance_double(Mud::Server, broadcast: nil) }

    before { allow(Mud::Server).to receive(:instance).and_return(server) }

    it 'sends formatted message to self' do
      player.say('hello')
      expect(client).to have_received(:puts).with("You say, 'hello'")
    end

    it 'broadcasts to others' do
      player.say('hello')
      expect(server).to have_received(:broadcast).with("Alice says, 'hello'", except: player)
    end
  end

  describe '#run' do
    let(:server) { instance_double(Mud::Server, broadcast: nil) }

    before { allow(Mud::Server).to receive(:instance).and_return(server) }

    it 'reads input and calls say until disconnect' do
      allow(client).to receive(:gets).and_return("hello\n", "world\n", nil)
      player.run
      expect(client).to have_received(:puts).with("You say, 'hello'")
      expect(client).to have_received(:puts).with("You say, 'world'")
    end
  end
end
