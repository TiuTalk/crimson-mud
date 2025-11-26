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

    it 'creates Client with socket and server, calls handle' do
      server.send(:handle_connection, socket)

      expect(Mud::Network::Client).to have_received(:new).with(socket:, server:)
      expect(client).to have_received(:handle)
    end
  end

  describe '#add_client' do
    it 'adds client to clients set' do
      server.add_client(client)

      expect(server.clients).to include(client)
    end
  end

  describe '#remove_client' do
    before { server.add_client(client) }

    it 'removes client from clients set' do
      server.remove_client(client)

      expect(server.clients).not_to include(client)
    end
  end

  describe '#broadcast' do
    let(:alice) { instance_double(Mud::Network::Client, puts: nil) }
    let(:bob) { instance_double(Mud::Network::Client, puts: nil) }

    before do
      server.add_client(alice)
      server.add_client(bob)
    end

    it 'sends message to all registered clients' do
      server.broadcast('hello')

      expect(alice).to have_received(:puts).with('hello')
      expect(bob).to have_received(:puts).with('hello')
    end

    it 'skips excepted client' do
      server.broadcast('hello', except: alice)

      expect(alice).not_to have_received(:puts)
      expect(bob).to have_received(:puts).with('hello')
    end
  end
end
