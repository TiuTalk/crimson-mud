# frozen_string_literal: true

require 'logger'

RSpec.describe Mud::Telnet::Server do
  subject(:server) { described_class.instance }

  let(:logger) { instance_double(Logger, info: nil, error: nil) }
  let(:tcp_server) { instance_double(TCPServer, close: nil, closed?: false) }

  before do
    server.instance_variable_set(:@server, nil)
    allow(Mud).to receive(:logger).and_return(logger)
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

    it 'handles not started' do
      expect { server.stop }.not_to raise_error
    end
  end

  describe '#handle_client' do
    let(:socket) do
      instance_double(TCPSocket, puts: nil, gets: nil, close: nil, closed?: false,
        read: nil, write: nil, remote_address: addrinfo)
    end
    let(:addrinfo) { instance_double(Addrinfo, ip_address: '127.0.0.1', ip_port: 12_345) }

    it 'sends welcome message' do
      server.handle_client(socket:)
      expect(socket).to have_received(:puts).with('Welcome to Crimson MUD!')
    end

    it 'logs connection' do
      server.handle_client(socket:)
      expect(logger).to have_received(:info).with(/Connected.*127.0.0.1:12345/)
    end

    it 'logs disconnection' do
      server.handle_client(socket:)
      expect(logger).to have_received(:info).with(/Disconnected.*127.0.0.1:12345/)
    end
  end
end
