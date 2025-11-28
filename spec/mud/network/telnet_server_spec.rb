# frozen_string_literal: true

RSpec.describe Mud::Network::TelnetServer do
  subject(:telnet_server) { described_class.new }

  let(:logger) { instance_double(Logger, info: nil) }
  let(:tcp_server) { instance_double(TCPServer, close: nil) }

  before do
    allow(TCPServer).to receive(:new).and_return(tcp_server)
    allow(Mud).to receive(:logger).and_return(logger)
  end

  describe '#start' do
    it 'logs server started' do
      allow(tcp_server).to receive(:accept).and_raise(Errno::EBADF)
      telnet_server.start
      expect(logger).to have_received(:info).with('Server started on port 4001')
    end

    it 'spawns thread to handle connection' do
      socket = instance_double(TCPSocket)
      server = instance_double(Mud::Server, handle_connection: nil)
      call_count = 0
      allow(tcp_server).to receive(:accept) do
        call_count += 1
        call_count == 1 ? socket : raise(Errno::EBADF)
      end
      allow(Mud::Server).to receive(:instance).and_return(server)

      telnet_server.start
      sleep 0.01

      expect(server).to have_received(:handle_connection).with(socket)
    end
  end

  describe '#stop' do
    it 'closes socket and logs' do
      allow(tcp_server).to receive(:accept).and_raise(Errno::EBADF)
      telnet_server.start
      telnet_server.stop
      expect(tcp_server).to have_received(:close)
      expect(logger).to have_received(:info).with('Server stopped')
    end
  end
end
