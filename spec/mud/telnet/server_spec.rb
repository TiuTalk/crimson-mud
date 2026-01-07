# frozen_string_literal: true

require 'logger'

RSpec.describe Mud::Telnet::Server do
  subject(:server) { described_class.instance }

  let(:logger) { instance_double(Logger, info: nil, error: nil) }
  let(:tcp_server) { instance_double(TCPServer, close: nil, closed?: false) }
  let(:world) { instance_double(Mud::World, add_player: nil, remove_player: nil) }

  before do
    allow(Mud).to receive_messages(logger:, world:)
    allow(TCPServer).to receive(:new).and_return(tcp_server)
    allow(tcp_server).to receive(:accept).and_raise(IOError)
  end

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

    it 'adds player to world' do
      server.handle_client(socket:)
      expect(world).to have_received(:add_player).with(instance_of(Mud::Player))
    end

    it 'removes player from world on disconnect' do
      server.handle_client(socket:)
      expect(world).to have_received(:remove_player).with(instance_of(Mud::Player))
    end
  end
end
