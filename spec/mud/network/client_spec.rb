# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Network::Client do
  subject(:client) { described_class.new(socket:, server:) }

  let(:socket) { instance_double(TCPSocket, puts: nil, close: nil, peeraddr:) }
  let(:peeraddr) { ['AF_INET', 1234, 'localhost', '192.168.1.100'] }
  let(:server) { instance_double(Mud::Network::Server, add_client: nil, remove_client: nil, broadcast: nil) }

  describe '#handle' do
    before do
      allow(socket).to receive(:gets).and_return(nil)
      allow(Mud.logger).to receive(:info)
    end

    it 'adds client to server on start' do
      client.handle

      expect(server).to have_received(:add_client).with(client)
    end

    it 'removes client from server on disconnect' do
      client.handle

      expect(server).to have_received(:remove_client).with(client)
    end

    it 'logs client connected with IP' do
      client.handle

      expect(Mud.logger).to have_received(:info).with('Client [192.168.1.100] connected')
    end

    it 'logs client disconnected with IP' do
      client.handle

      expect(Mud.logger).to have_received(:info).with('Client [192.168.1.100] disconnected')
    end

    it 'broadcasts messages with IP prefix' do
      allow(socket).to receive(:gets).and_return("hello\n", "world\n", nil)

      client.handle

      expect(server).to have_received(:broadcast).with('[192.168.1.100] hello').ordered
      expect(server).to have_received(:broadcast).with('[192.168.1.100] world').ordered
    end

    it 'closes socket on disconnect' do
      allow(socket).to receive(:gets).and_return(nil)

      client.handle

      expect(socket).to have_received(:close)
    end
  end

  describe '#puts' do
    it 'delegates to socket' do
      client.puts('hello')

      expect(socket).to have_received(:puts).with('hello')
    end
  end
end
