# frozen_string_literal: true

require 'socket'

RSpec.describe Mud::Telnet::Client do
  subject(:client) { described_class.new(socket) }

  let(:socket) do
    instance_double(TCPSocket, puts: nil, close: nil, gets: nil, read: nil, write: nil,
      remote_address: addrinfo, closed?: false)
  end
  let(:addrinfo) { instance_double(Addrinfo, ip_address: '127.0.0.1', ip_port: 12_345) }

  describe '#gets' do
    it 'delegates to socket' do
      allow(socket).to receive(:gets).and_return("hello\n")
      expect(client.gets).to eq("hello\n")
    end
  end

  describe '#puts' do
    it 'delegates to socket' do
      client.puts('hello')
      expect(socket).to have_received(:puts).with('hello')
    end
  end

  describe '#read' do
    it 'delegates to socket' do
      allow(socket).to receive(:read).and_return('data')
      expect(client.read).to eq('data')
    end
  end

  describe '#write' do
    it 'delegates to socket' do
      client.write('data')
      expect(socket).to have_received(:write).with('data')
    end
  end

  describe '#close' do
    it 'closes socket' do
      client.close
      expect(socket).to have_received(:close)
    end

    it 'does not close already closed socket' do
      allow(socket).to receive(:closed?).and_return(true)
      client.close
      expect(socket).not_to have_received(:close)
    end
  end

  describe '#closed?' do
    it { is_expected.not_to be_closed }

    it 'delegates to socket' do
      allow(socket).to receive(:closed?).and_return(true)
      expect(client).to be_closed
    end
  end

  describe '#remote_address' do
    it 'returns ip:port string' do
      expect(client.remote_address).to eq('127.0.0.1:12345')
    end
  end
end
