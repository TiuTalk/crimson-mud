# frozen_string_literal: true

RSpec.describe Mud::Commands::Quit do
  subject(:command) { described_class.new(player:) }

  let(:player) { instance_double(Mud::Player, quit: nil) }

  it_behaves_like 'a registered command', 'quit'

  describe '#perform' do
    it 'calls player.quit' do
      command.perform
      expect(player).to have_received(:quit)
    end
  end
end
