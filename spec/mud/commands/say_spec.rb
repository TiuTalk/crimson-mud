# frozen_string_literal: true

RSpec.describe Mud::Commands::Say do
  let(:player) { instance_double(Mud::Player, puts: nil) }
  let(:server) { instance_double(Mud::Telnet::Server, broadcast: nil) }

  before { allow(Mud).to receive(:server).and_return(server) }

  it 'registers as say' do
    expect(Mud::Commands::Registry.lookup('say')).to eq(described_class)
  end

  describe '#perform' do
    it 'echoes message to player' do
      described_class.new(player:).perform('hello')

      expect(player).to have_received(:puts).with("You say 'hello'")
    end

    it 'broadcasts to other players' do
      described_class.new(player:).perform('hello')

      expect(server).to have_received(:broadcast).with("Someone says 'hello'", except: player)
    end

    it 'strips whitespace from message' do
      described_class.new(player:).perform('  hello world  ')

      expect(player).to have_received(:puts).with("You say 'hello world'")
    end

    it 'strips color codes from message' do
      described_class.new(player:).perform('&rhello')

      expect(player).to have_received(:puts).with("You say 'hello'")
    end
  end
end
