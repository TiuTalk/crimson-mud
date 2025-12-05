# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Network::Client do
  subject(:client) { described_class.new(socket:) }

  let(:socket) { instance_double(TCPSocket, puts: nil, write: nil, gets: nil, close: nil, remote_address:) }
  let(:remote_address) { instance_double(Addrinfo, ip_address: '192.168.1.100') }

  describe '#puts' do
    it 'writes to socket' do
      expect(socket).to receive(:puts).with('hello')
      client.puts('hello')
    end

    it 'parses colors before writing to socket' do
      expect(socket).to receive(:puts).with("\e[31mhello\e[0m")
      client.puts('&rhello')
    end

    it 'silently ignores IOError' do
      allow(socket).to receive(:puts).and_raise(IOError)

      expect { client.puts('hello') }.not_to raise_error
    end

    it 'silently ignores Errno::EPIPE' do
      allow(socket).to receive(:puts).and_raise(Errno::EPIPE)

      expect { client.puts('hello') }.not_to raise_error
    end
  end

  describe '#write' do
    it 'writes to socket' do
      expect(socket).to receive(:write).with('hello')
      client.write('hello')
    end

    it 'parses colors before writing to socket' do
      expect(socket).to receive(:write).with("\e[31mhello\e[0m")
      client.write('&rhello')
    end

    it 'silently ignores IOError' do
      allow(socket).to receive(:write).and_raise(IOError)

      expect { client.write('hello') }.not_to raise_error
    end

    it 'silently ignores Errno::EPIPE' do
      allow(socket).to receive(:write).and_raise(Errno::EPIPE)

      expect { client.write('hello') }.not_to raise_error
    end
  end

  describe '#gets' do
    it 'delegates to socket' do
      allow(socket).to receive(:gets).and_return("hello\n")

      expect(client.gets).to eq("hello\n")
    end

    it 'strips ANSI codes from input' do
      allow(socket).to receive(:gets).and_return("\e[34mhacked\n")

      expect(client.gets).to eq("hacked\n")
    end

    it 'returns nil on IOError' do
      allow(socket).to receive(:gets).and_raise(IOError)

      expect(client.gets).to be_nil
    end

    it 'returns nil on Errno::EPIPE' do
      allow(socket).to receive(:gets).and_raise(Errno::EPIPE)

      expect(client.gets).to be_nil
    end
  end

  describe '#close' do
    it 'delegates to socket' do
      expect(socket).to receive(:close)
      client.close
    end

    it 'silently ignores IOError' do
      allow(socket).to receive(:close).and_raise(IOError)

      expect { client.close }.not_to raise_error
    end

    it 'silently ignores Errno::EBADF' do
      allow(socket).to receive(:close).and_raise(Errno::EBADF)

      expect { client.close }.not_to raise_error
    end
  end

  describe '#ip_address' do
    it 'returns socket remote address' do
      expect(client.ip_address).to eq('192.168.1.100')
    end

    it 'returns unknown on IOError' do
      allow(remote_address).to receive(:ip_address).and_raise(IOError)

      expect(client.ip_address).to eq('unknown')
    end

    it 'returns unknown on Errno::EBADF' do
      allow(socket).to receive(:remote_address).and_raise(Errno::EBADF)

      expect(client.ip_address).to eq('unknown')
    end
  end
end
