# frozen_string_literal: true

RSpec.describe Mud::Commands::Look do
  let(:room) { instance_double(Mud::Room, name: 'Test Room', description: 'A test description.') }
  let(:player) { instance_double(Mud::Player, room:, puts: nil) }

  it 'registers as look' do
    expect(Mud::Commands::Registry.lookup('look')).to eq(described_class)
  end

  describe '#perform' do
    before { described_class.new(player:).perform('') }

    let(:expected) { "&cTest Room&n\nA test description." }

    it { expect(player).to have_received(:puts).with(expected) }
  end
end
