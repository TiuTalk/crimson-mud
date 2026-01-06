# frozen_string_literal: true

RSpec.describe Mud::Commands::Quit do
  let(:player) { instance_double(Mud::Player, quit: nil) }

  it_behaves_like 'a registered command', 'quit'

  describe '#perform' do
    it 'calls player.quit' do
      described_class.new(player:).perform('')

      expect(player).to have_received(:quit)
    end
  end
end
