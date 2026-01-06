# frozen_string_literal: true

require 'logger'

RSpec.describe Mud::Telnet::Server do
  subject(:server) { described_class.instance }

  let(:logger) { instance_double(Logger, info: nil, error: nil) }
  let(:tcp_server) { instance_double(TCPServer, close: nil, closed?: false) }

  before do
    allow(Mud).to receive(:logger).and_return(logger)
    allow(TCPServer).to receive(:new).and_return(tcp_server)
    allow(tcp_server).to receive(:accept).and_raise(IOError)
  end

  after { server.clear_players }

  describe '#start' do
    it 'binds socket and logs' do
      server.start
      expect(TCPServer).to have_received(:new).with('127.0.0.1', 4001)
      expect(logger).to have_received(:info).with(/listening/)
    end
  end

  describe '#stop' do
    it 'closes server when running' do
      server.start
      expect(tcp_server).to have_received(:close)
    end
  end

  describe '#add_player' do
    let(:player) { instance_double(Mud::Player) }

    it 'adds player to players list' do
      server.add_player(player)
      expect(server.players).to include(player)
    end
  end

  describe '#remove_player' do
    let(:player) { instance_double(Mud::Player) }

    before { server.add_player(player) }

    it 'removes player from players list' do
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

    it 'sends message to all players' do
      server.broadcast('Hello')
      expect(alice).to have_received(:puts).with('Hello')
      expect(bob).to have_received(:puts).with('Hello')
    end

    it 'excludes specified player' do
      server.broadcast('Hello', except: alice)
      expect(alice).not_to have_received(:puts)
      expect(bob).to have_received(:puts).with('Hello')
    end
  end

  describe '#handle_client' do
    let(:socket) do
      instance_double(TCPSocket, puts: nil, close: nil, closed?: false,
        read: nil, write: nil, remote_address: addrinfo)
    end
    let(:addrinfo) { instance_double(Addrinfo, ip_address: '127.0.0.1', ip_port: 12_345) }

    before { allow(socket).to receive(:gets).and_return("Alice\n", nil) }

    it 'sends welcome message' do
      server.handle_client(socket:)
      expect(socket).to have_received(:puts).with('Welcome to Crimson MUD!')
    end

    it 'prompts for name' do
      server.handle_client(socket:)
      expect(socket).to have_received(:puts).with('What is your name?')
    end

    it 'greets player by name' do
      server.handle_client(socket:)
      expect(socket).to have_received(:puts).with('Welcome, Alice!')
    end

    it 'creates player with name and starting room' do
      allow(Mud::Player).to receive(:new).and_call_original
      server.handle_client(socket:)
      expect(Mud::Player).to have_received(:new).with(name: 'Alice', room: Mud::Room.starting, client: anything)
    end

    context 'when name is empty' do
      before { allow(socket).to receive(:gets).and_return("\n") }

      it 'does not create player' do
        allow(Mud::Player).to receive(:new)
        server.handle_client(socket:)
        expect(Mud::Player).not_to have_received(:new)
      end
    end

    context 'when client disconnects during name prompt' do
      before { allow(socket).to receive(:gets).and_return(nil) }

      it 'does not create player' do
        allow(Mud::Player).to receive(:new)
        server.handle_client(socket:)
        expect(Mud::Player).not_to have_received(:new)
      end
    end

    it 'logs connection with player name' do
      server.handle_client(socket:)
      expect(logger).to have_received(:info).with('Connected: Alice (127.0.0.1:12345)')
    end

    it 'logs disconnection with player name' do
      server.handle_client(socket:)
      expect(logger).to have_received(:info).with('Disconnected: Alice (127.0.0.1:12345)')
    end

    context 'when client disconnects before entering name' do
      before { allow(socket).to receive(:gets).and_return(nil) }

      it 'does not log connection' do
        server.handle_client(socket:)
        expect(logger).not_to have_received(:info).with(/Connected/)
      end

      it 'logs disconnection with IP only' do
        server.handle_client(socket:)
        expect(logger).to have_received(:info).with('Disconnected: 127.0.0.1:12345')
      end
    end

    it 'removes player from registry on disconnect' do
      server.handle_client(socket:)
      expect(server.players).to be_empty
    end
  end
end
