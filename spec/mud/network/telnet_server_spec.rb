# frozen_string_literal: true

RSpec.describe Mud::Network::TelnetServer do
  subject(:telnet_server) { described_class.new }

  let(:tcp_server) { instance_double(TCPServer, close: nil) }

  before do
    allow(TCPServer).to receive(:new).and_return(tcp_server)
    allow(tcp_server).to receive(:accept).and_raise(Errno::EBADF)
  end

  describe '#start' do
    it 'creates TCP server' do
      expect(TCPServer).to receive(:new)
      telnet_server.start
    end
  end

  describe '#stop' do
    it 'closes TCP server' do
      telnet_server.start
      expect(tcp_server).to receive(:close)
      telnet_server.stop
    end
  end

  describe '#handle_client' do
    let(:socket) { instance_double(TCPSocket) }
    let(:server) { instance_double(Mud::Server) }

    before { allow(Mud::Server).to receive(:instance).and_return(server) }

    it 'delegates to Server' do
      expect(server).to receive(:handle_connection).with(socket)
      telnet_server.handle_client(socket)
    end
  end
end
