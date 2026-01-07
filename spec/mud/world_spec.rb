# frozen_string_literal: true

RSpec.describe Mud::World do
  subject(:world) { described_class.instance }

  let(:room) { instance_double(Mud::Room, add_player: nil, remove_player: nil) }
  let(:alice) { instance_double(Mud::Player, room:, puts: nil) }
  let(:bob) { instance_double(Mud::Player, room:, puts: nil) }

  after { world.clear }

  describe '#add_player' do
    it 'adds player to players set' do
      world.add_player(alice)
      expect(world.players).to include(alice)
    end

    it 'adds player to their room' do
      world.add_player(alice)
      expect(room).to have_received(:add_player).with(alice)
    end
  end

  describe '#remove_player' do
    before { world.add_player(alice) }

    it 'removes player from players set' do
      world.remove_player(alice)
      expect(world.players).not_to include(alice)
    end

    it 'removes player from their room' do
      world.remove_player(alice)
      expect(room).to have_received(:remove_player).with(alice)
    end
  end

  describe '#broadcast' do
    before do
      world.add_player(alice)
      world.add_player(bob)
    end

    it 'sends message to all players' do
      world.broadcast('Hello')
      expect(alice).to have_received(:puts).with('Hello')
      expect(bob).to have_received(:puts).with('Hello')
    end

    it 'excludes specified player' do
      world.broadcast('Hello', except: alice)
      expect(alice).not_to have_received(:puts)
      expect(bob).to have_received(:puts).with('Hello')
    end
  end
end
