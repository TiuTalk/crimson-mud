# frozen_string_literal: true

RSpec.describe Mud::Player do
  subject(:player) { described_class.new(client:, name: 'Alice') }

  let(:client) do
    instance_double(Mud::Telnet::Client, gets: nil, puts: nil, read: nil, write: nil, close: nil)
  end

  describe '#name' do
    it 'returns the name' do
      expect(player.name).to eq('Alice')
    end
  end

  describe '#client' do
    it 'returns the client' do
      expect(player.client).to eq(client)
    end
  end

  describe '#quit' do
    it 'says goodbye' do
      player.quit
      expect(client).to have_received(:puts).with('Goodbye, Alice!')
    end

    it 'closes the client' do
      player.quit
      expect(client).to have_received(:close)
    end
  end

  describe '#run' do
    let(:processor) { instance_double(Mud::Commands::Processor, process: nil) }

    before { allow(Mud::Commands::Processor).to receive(:new).and_return(processor) }

    it 'processes input via processor' do
      allow(client).to receive(:gets).and_return("say hello\n", nil)
      player.run
      expect(processor).to have_received(:process).with('say hello')
    end

    it 'skips empty input' do
      allow(client).to receive(:gets).and_return("  \n", nil)
      player.run
      expect(processor).not_to have_received(:process)
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
