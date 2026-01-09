# frozen_string_literal: true

RSpec.describe Mud::Commands::Tell do
  let(:alice) { instance_double(Mud::Player, puts: nil, name: 'Alice') }
  let(:bob) { instance_double(Mud::Player, puts: nil, name: 'Bob') }

  before { allow(Mud.world).to receive(:players).and_return([alice, bob]) }

  it_behaves_like 'a registered command', 'tell'

  describe '#perform' do
    it 'sends message to target in magenta' do
      described_class.new(player: alice).perform('Bob hello there')

      expect(bob).to have_received(:puts).with("&mAlice tells you, 'hello there'")
    end

    it 'confirms to sender in magenta' do
      described_class.new(player: alice).perform('Bob hello there')

      expect(alice).to have_received(:puts).with("&mYou tell Bob, 'hello there'")
    end

    it 'handles case-insensitive names' do
      described_class.new(player: alice).perform('bob test')

      expect(bob).to have_received(:puts).with("&mAlice tells you, 'test'")
    end

    context 'when target not found' do
      it 'notifies sender without color' do
        described_class.new(player: alice).perform('Charlie hello')

        expect(alice).to have_received(:puts).with('No player by that name is connected.')
      end
    end

    context 'when telling self' do
      it 'rejects without color' do
        described_class.new(player: alice).perform('Alice hello')

        expect(alice).to have_received(:puts).with('Talking to yourself again?')
      end
    end

    context 'with no arguments' do
      it 'prompts without color' do
        described_class.new(player: alice).perform('')

        expect(alice).to have_received(:puts).with('Tell whom what?')
      end
    end
  end
end
