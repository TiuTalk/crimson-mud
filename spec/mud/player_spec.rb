# frozen_string_literal: true

RSpec.describe Mud::Player do
  subject(:player) { described_class.new(client:) }

  let(:client) do
    instance_double(Mud::Telnet::Client, gets: nil, puts: nil, read: nil, write: nil, close: nil)
  end

  describe '#client' do
    it 'returns the client' do
      expect(player.client).to eq(client)
    end
  end

  describe '#run' do
    it 'echoes chomped input back' do
      allow(client).to receive(:gets).and_return("hello\n", nil)
      player.run
      expect(client).to have_received(:puts).with('hello')
    end

    it 'breaks on quit' do
      allow(client).to receive(:gets).and_return("quit\n")
      player.run
      expect(client).not_to have_received(:puts)
    end

    it 'closes client on exit' do
      player.run
      expect(client).to have_received(:close)
    end
  end

  describe 'delegations' do
    it 'delegates #gets to client' do
      allow(client).to receive(:gets).and_return('input')
      expect(player.gets).to eq('input')
    end

    it 'delegates #puts to client' do
      player.puts('hello')
      expect(client).to have_received(:puts).with('hello')
    end

    it 'delegates #read to client' do
      allow(client).to receive(:read).and_return('data')
      expect(player.read).to eq('data')
    end

    it 'delegates #write to client' do
      player.write('data')
      expect(client).to have_received(:write).with('data')
    end

    it 'delegates #close to client' do
      player.close
      expect(client).to have_received(:close)
    end
  end
end
