# frozen_string_literal: true

RSpec.describe Mud::Commands::Commands do
  let(:player) { instance_double(Mud::Player, puts: nil) }

  it 'registers as commands' do
    expect(Mud::Commands::Registry.lookup('commands')).to eq(described_class)
  end

  describe '#perform' do
    before do
      allow(Mud::Commands::Registry).to receive(:keywords).and_return(keywords)
      described_class.new(player:).perform('')
    end

    context 'with 8 keywords' do
      let(:keywords) { %i[a bb ccc dddd e f g h] }
      let(:expected) { "Available commands:\na        bb       ccc      dddd\ne        f        g        h" }

      it { expect(player).to have_received(:puts).with(expected) }
    end

    context 'with varied length keywords' do
      let(:keywords) { %i[a longcommand] }
      let(:expected) { "Available commands:\na               longcommand" }

      it { expect(player).to have_received(:puts).with(expected) }
    end
  end
end
