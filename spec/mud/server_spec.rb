# frozen_string_literal: true

RSpec.describe Mud::Server do
  subject(:server) { described_class.instance }

  after { server.players.clear }

  describe '.instance' do
    it { is_expected.to equal(described_class.instance) }
  end

  describe '#add_player' do
    let(:player) { instance_double(Mud::Player) }

    it 'adds to players set' do
      server.add_player(player)
      expect(server.players).to include(player)
    end
  end

  describe '#remove_player' do
    let(:player) { instance_double(Mud::Player) }

    it 'removes from players set' do
      server.add_player(player)
      server.remove_player(player)
      expect(server.players).not_to include(player)
    end
  end

  describe '#broadcast' do
    let(:alice) { instance_double(Mud::Player, name: 'Alice', puts: nil) }
    let(:bob) { instance_double(Mud::Player, name: 'Bob', puts: nil) }

    before do
      server.add_player(alice)
      server.add_player(bob)
    end

    it 'sends to all players except excluded' do
      expect(alice).not_to receive(:puts)
      expect(bob).to receive(:puts).with('hello')
      server.broadcast('hello', except: alice)
    end
  end

  describe '#welcome' do
    let(:client) { instance_double(Mud::Network::Client, puts: nil) }

    before { allow(client).to receive(:gets).and_return("Alice\n") }

    it 'sends blank line after MOTD' do
      expect(client).to receive(:puts).with("Welcome to Crimson MUD!\n").ordered
      expect(client).to receive(:puts).with('What is your name?').ordered
      server.send(:welcome, client)
    end
  end

  describe '#handle_connection' do
    let(:socket) { instance_double(TCPSocket) }
    let(:client) { instance_double(Mud::Network::Client, puts: nil, write: nil, close: nil, ip_address: '127.0.0.1') }

    before do
      allow(Mud::Network::Client).to receive(:new).and_return(client)
      allow(client).to receive(:gets).and_return("Alice\n", nil)
    end

    it 'creates player and runs until disconnect' do
      expect(client).to receive(:close)
      server.handle_connection(socket)
    end

    it 'broadcasts arrived message excluding player' do
      expect(server).to receive(:broadcast).with('Alice arrived.', except: an_instance_of(Mud::Player))
      allow(server).to receive(:broadcast).with('Alice left.')
      server.handle_connection(socket)
    end

    it 'broadcasts left message on disconnect' do
      allow(server).to receive(:broadcast).with('Alice arrived.', except: an_instance_of(Mud::Player))
      expect(server).to receive(:broadcast).with('Alice left.')
      server.handle_connection(socket)
    end

    it 'sends personalized welcome to player' do
      allow(server).to receive(:broadcast)
      expect(client).to receive(:puts).with('Welcome, Alice!')
      server.handle_connection(socket)
    end
  end
end
