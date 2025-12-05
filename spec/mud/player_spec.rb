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
      expect(client).to receive(:puts).with('hello')
      player.puts('hello')
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
      expect(client).to receive(:puts).with('Goodbye!')
      player.quit
    end

    it 'closes client' do
      expect(client).to receive(:close)
      player.quit
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
      expect(client).to receive(:puts).with('Unknown command: foobar')
      player.run
    end

    it 'skips empty input' do
      allow(client).to receive(:gets).and_return("\n", "  \n", nil)
      expect(client).not_to receive(:puts)
      player.run
    end

    it 'logs input before command execution' do
      allow(client).to receive(:gets).and_return("say hello\n", nil)
      allow(Mud.logger).to receive(:debug)
      expect(Mud.logger).to receive(:debug).with('Alice input "say hello"').ordered
      player.run
    end
  end
end
