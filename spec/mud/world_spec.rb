# frozen_string_literal: true

RSpec.describe Mud::World do
  subject(:world) { described_class.instance }

  let(:room) { instance_double(Mud::Room, add_player: nil, remove_player: nil) }
  let(:alice) { instance_double(Mud::Player, room:, puts: nil) }
  let(:bob) { instance_double(Mud::Player, room:, puts: nil) }

  after { world.clear }

  it_behaves_like 'has players'

  describe '#add_player' do
    it 'adds player to their room' do
      world.add_player(alice)
      expect(room).to have_received(:add_player).with(alice)
    end
  end

  describe '#remove_player' do
    before { world.add_player(alice) }

    it 'removes player from their room' do
      world.remove_player(alice)
      expect(room).to have_received(:remove_player).with(alice)
    end
  end
end
