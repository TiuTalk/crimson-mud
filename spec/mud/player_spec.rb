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

  describe '#disconnect' do
    it 'closes client' do
      player.disconnect

      expect(client).to have_received(:close)
    end
  end

  describe '#ip_address' do
    it 'delegates to client' do
      expect(player.ip_address).to eq('192.168.1.100')
    end
  end
end
