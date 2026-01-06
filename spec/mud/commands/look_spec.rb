# frozen_string_literal: true

RSpec.describe Mud::Commands::Look do
  let(:room) { instance_double(Mud::Room, name: 'Test Room', description: 'A test description.') }
  let(:player) { instance_double(Mud::Player, room:, puts: nil) }

  it_behaves_like 'a registered command', 'look'

  describe '#perform' do
    before { described_class.new(player:).perform('') }

    let(:expected) { "&cTest Room&n\nA test description." }

    it 'outputs room name and description' do
      expect(player).to have_received(:puts).with(expected)
    end
  end
end
