# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Network::Server do
  subject(:server) { described_class.new(port: 4000) }

  let(:tcp_server) { instance_double(TCPServer) }
  let(:socket) { instance_double(TCPSocket) }
  let(:client) { instance_double(Mud::Network::Client, handle: nil) }

  describe '#start' do
    before { allow(TCPServer).to receive(:new).and_return(tcp_server) }

    it 'binds to the specified port' do
      allow(tcp_server).to receive(:accept).and_raise(IOError)

      expect { server.start }.to raise_error(IOError)
      expect(TCPServer).to have_received(:new).with(4000)
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
