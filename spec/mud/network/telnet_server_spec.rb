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
      telnet_server.start
      expect(TCPServer).to have_received(:new)
    end
  end

  describe '#stop' do
    it 'closes TCP server' do
      telnet_server.start
      telnet_server.stop
      expect(tcp_server).to have_received(:close)
    end
  end

  describe '#handle_client' do
    let(:socket) { instance_double(TCPSocket) }
    let(:server) { instance_double(Mud::Server, handle_connection: nil) }

    before { allow(Mud::Server).to receive(:instance).and_return(server) }

    it 'delegates to Server' do
      telnet_server.handle_client(socket)
      expect(server).to have_received(:handle_connection).with(socket)
    end
  end
end
