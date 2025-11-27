# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Network::Server do
  subject(:server) { described_class.instance }

  let(:logger) { instance_double(Logger, info: nil) }
  let(:client) { instance_double(Mud::Network::Client, puts: nil, gets: nil, close: nil, ip_address: '192.168.1.100') }
  let(:socket) { instance_double(TCPSocket) }
  let(:tcp_server) { instance_double(TCPServer, close: nil) }

  after { server.players.clear }

  before do
    allow(TCPServer).to receive(:new).and_return(tcp_server)
    allow(Mud).to receive(:logger).and_return(logger)
  end

  describe '.instance' do
    it { is_expected.to equal(described_class.instance) }
  end

  describe '#start' do
    it 'logs server started' do
      allow(tcp_server).to receive(:accept).and_raise(Errno::EBADF)
      server.start
      expect(logger).to have_received(:info).with('Server started on port 4000')
    end
  end

  describe '#stop' do
    it 'closes socket and logs' do
      allow(tcp_server).to receive(:accept).and_raise(Errno::EBADF)
      server.start
      server.stop
      expect(tcp_server).to have_received(:close)
      expect(logger).to have_received(:info).with('Server stopped')
    end
  end

  describe '#add_player / #remove_player' do
    let(:player) { instance_double(Mud::Player) }

    it 'manages players set' do
      server.add_player(player)
      expect(server.players).to include(player)

      server.remove_player(player)
      expect(server.players).not_to include(player)
    end
  end

  describe '#broadcast' do
    let(:alice) { instance_double(Mud::Player, puts: nil) }
    let(:bob) { instance_double(Mud::Player, puts: nil) }

    before do
      server.add_player(alice)
      server.add_player(bob)
    end

    it 'sends to all players except excluded' do
      server.broadcast('hello', except: alice)
      expect(alice).not_to have_received(:puts)
      expect(bob).to have_received(:puts).with('hello')
    end
  end

  describe '#handle_connection' do
    before do
      allow(Mud::Network::Client).to receive(:new).and_return(client)
      allow(client).to receive(:gets).and_return("Alice\n", nil)
    end

    it 'sends welcome and prompts for name' do
      server.send(:handle_connection, socket)
      expect(client).to have_received(:puts).with('Welcome to Crimson MUD!')
      expect(client).to have_received(:puts).with('What is your name?')
    end

    it 'creates player with name and client' do
      allow(Mud::Player).to receive(:new).and_call_original
      server.send(:handle_connection, socket)
      expect(Mud::Player).to have_received(:new).with(name: 'Alice', client:)
    end

    it 'logs connect and disconnect' do
      server.send(:handle_connection, socket)
      expect(logger).to have_received(:info).with('Alice connected (192.168.1.100)')
      expect(logger).to have_received(:info).with('Alice disconnected (192.168.1.100)')
    end

    it 'closes client on disconnect' do
      server.send(:handle_connection, socket)
      expect(client).to have_received(:close)
    end

    it 'handles disconnect before name' do
      allow(client).to receive(:gets).and_return(nil)

      server.send(:handle_connection, socket)

      expect(logger).to have_received(:info).with('Visitor disconnected (192.168.1.100)')
    end

    it 're-prompts on empty name' do
      allow(client).to receive(:gets).and_return("\n", "Bob\n", nil)

      server.send(:handle_connection, socket)

      expect(client).to have_received(:puts).with('What is your name?').twice
    end

    it 'echoes message and broadcasts to others' do
      allow(client).to receive(:gets).and_return("Alice\n", "hello\n", nil)
      other = instance_double(Mud::Player, puts: nil)
      server.add_player(other)

      server.send(:handle_connection, socket)

      expect(client).to have_received(:puts).with("You say, 'hello'")
      expect(other).to have_received(:puts).with("Alice says, 'hello'")
    end
  end
end
