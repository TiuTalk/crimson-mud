# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Network::Client do
  subject(:client) { described_class.new(socket) }

  let(:socket) { instance_double(TCPSocket, puts: nil, close: nil, peeraddr:) }
  let(:peeraddr) { ['AF_INET', 1234, 'localhost', '192.168.1.100'] }

  describe '#handle' do
    before do
      allow(socket).to receive(:gets).and_return(nil)
      allow(Mud.logger).to receive(:info)
    end

    it 'logs client connected with IP' do
      client.handle

      expect(Mud.logger).to have_received(:info).with('Client [192.168.1.100] connected')
    end

    it 'logs client disconnected with IP' do
      client.handle

      expect(Mud.logger).to have_received(:info).with('Client [192.168.1.100] disconnected')
    end

    it 'echoes each line back to client' do
      allow(socket).to receive(:gets).and_return("hello\n", "world\n", nil)

      client.handle

      expect(socket).to have_received(:puts).with("hello\n").ordered
      expect(socket).to have_received(:puts).with("world\n").ordered
    end

    it 'closes socket on disconnect' do
      allow(socket).to receive(:gets).and_return(nil)

      client.handle

      expect(socket).to have_received(:close)
    end
  end
end
