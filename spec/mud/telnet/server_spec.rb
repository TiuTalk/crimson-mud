# frozen_string_literal: true

require 'logger'

RSpec.describe Mud::Telnet::Server do
  subject(:server) { described_class.new(host: '127.0.0.1', port: 4000) }

  let(:logger) { instance_double(Logger, info: nil, error: nil) }
  let(:tcp_server) { instance_double(TCPServer, close: nil, closed?: false) }

  before do
    allow(Mud).to receive(:logger).and_return(logger)
    allow(TCPServer).to receive(:new).and_return(tcp_server)
    allow(tcp_server).to receive(:accept).and_raise(IOError)
  end

  describe '#start' do
    it 'binds socket and logs' do
      server.start
      expect(TCPServer).to have_received(:new).with('127.0.0.1', 4000)
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
end
