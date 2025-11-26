# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Network::Server do
  subject(:server) { described_class.new(port: 4000) }

  let(:tcp_server) { instance_double(TCPServer, close: nil) }
  let(:socket) { instance_double(TCPSocket) }
  let(:client) { instance_double(Mud::Network::Client, handle: nil) }
  let(:logger) { instance_double(Logger, info: nil) }

  before do
    allow(TCPServer).to receive(:new).and_return(tcp_server)
    allow(Mud).to receive(:logger).and_return(logger)
  end

  describe '#start' do
    it 'logs server started' do
      allow(tcp_server).to receive(:accept).and_raise(Errno::EBADF)

      server.start

      expect(logger).to have_received(:info).with('Server started on port 4000')
    end
  end

  describe '#stop' do
    before { allow(tcp_server).to receive(:accept).and_raise(Errno::EBADF) }

    it 'closes the server socket' do
      server.start
      server.stop

      expect(tcp_server).to have_received(:close)
    end

    it 'logs server stopped' do
      server.start
      server.stop

      expect(logger).to have_received(:info).with('Server stopped')
    end
  end

  describe '#handle_connection' do
    before { allow(Mud::Network::Client).to receive(:new).and_return(client) }

    it 'creates Client with socket and calls handle' do
      server.send(:handle_connection, socket)

      expect(Mud::Network::Client).to have_received(:new).with(socket)
      expect(client).to have_received(:handle)
    end
  end
end
