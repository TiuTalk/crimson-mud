# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Player do
  subject(:player) { described_class.new(name: 'Alice', client:) }

  let(:client) { instance_double(Mud::Network::Client, puts: nil, gets: nil, close: nil, ip_address: '192.168.1.100') }

  describe '#name' do
    it 'returns name' do
      expect(player.name).to eq('Alice')
    end
  end

  describe '#puts' do
    it 'delegates to client' do
      player.puts('hello')

      expect(client).to have_received(:puts).with('hello')
    end
  end

  describe '#gets' do
    it 'delegates to client' do
      allow(client).to receive(:gets).and_return("hello\n")

      expect(player.gets).to eq("hello\n")
    end
  end

  describe '#quit' do
    it 'sends goodbye message' do
      player.quit
      expect(client).to have_received(:puts).with('Goodbye!')
    end

    it 'closes client' do
      player.quit
      expect(client).to have_received(:close)
    end
  end

  describe '#ip_address' do
    it 'delegates to client' do
      expect(player.ip_address).to eq('192.168.1.100')
    end
  end

  describe '#run' do
    it 'executes commands via CommandRegistry' do
      allow(client).to receive(:gets).and_return("foobar\n", nil)
      player.run
      expect(client).to have_received(:puts).with('Unknown command: foobar')
    end

    it 'skips empty input' do
      allow(client).to receive(:gets).and_return("\n", "  \n", nil)
      player.run
      expect(client).not_to have_received(:puts)
    end
  end
end
