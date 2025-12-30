# frozen_string_literal: true

require 'logger'
require 'socket'

RSpec.describe Mud::Telnet::Connection do
  subject(:connection) { described_class.new(socket) }

  let(:logger) { instance_double(Logger, info: nil, error: nil) }
  let(:socket) do
    instance_double(TCPSocket, puts: nil, close: nil, gets: nil, remote_address: addrinfo, closed?: false)
  end
  let(:addrinfo) { instance_double(Addrinfo, ip_address: '127.0.0.1', ip_port: 12_345) }

  before { allow(Mud).to receive(:logger).and_return(logger) }

  describe '#handle' do
    it 'echoes input back to socket' do
      allow(socket).to receive(:gets).and_return("hello\n", nil)
      connection.handle
      expect(socket).to have_received(:puts).with('hello')
    end

    it 'closes on quit command' do
      allow(socket).to receive(:gets).and_return("quit\n")
      connection.handle
      expect(socket).to have_received(:close)
      expect(socket).not_to have_received(:puts)
    end

    it 'closes socket on disconnect' do
      connection.handle
      expect(socket).to have_received(:close)
    end

    it 'logs connection and disconnection' do
      connection.handle
      expect(logger).to have_received(:info).with(/Client connected/)
      expect(logger).to have_received(:info).with(/Client disconnected/)
    end

    it 'handles errors and closes socket' do
      allow(socket).to receive(:gets).and_raise(StandardError, 'test error')
      connection.handle
      expect(logger).to have_received(:error)
      expect(socket).to have_received(:close)
    end

    it 'handles already closed socket' do
      allow(socket).to receive_messages(gets: nil, closed?: true)
      connection.handle
      expect(socket).not_to have_received(:close)
    end
  end
end
