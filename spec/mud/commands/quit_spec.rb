# frozen_string_literal: true

RSpec.describe Mud::Commands::Quit do
  let(:player) { instance_double(Mud::Player, quit: nil) }

  it 'registers as quit' do
    expect(Mud::Commands::Registry.lookup('quit')).to eq(described_class)
  end

  describe '#perform' do
    it 'calls player.quit' do
      described_class.new(player:).perform('')

      expect(player).to have_received(:quit)
    end
  end
end
