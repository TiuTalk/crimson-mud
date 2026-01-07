# frozen_string_literal: true

RSpec.describe Mud::Room do
  subject(:room) { described_class.new(name: 'Town Square', description: 'A bustling square.') }

  let(:alice) { instance_double(Mud::Player, puts: nil) }
  let(:bob) { instance_double(Mud::Player, puts: nil) }

  describe '#name' do
    it { expect(room.name).to eq('Town Square') }
  end

  describe '#description' do
    it { expect(room.description).to eq('A bustling square.') }
  end

  describe '.starting' do
    it { expect(described_class.starting.name).to eq('The Void') }
  end

  describe '#players' do
    it { expect(room.players).to be_empty }
  end

  describe '#add_player' do
    it 'adds player to room' do
      room.add_player(alice)
      expect(room.players).to include(alice)
    end
  end

  describe '#remove_player' do
    before { room.add_player(alice) }

    it 'removes player from room' do
      room.remove_player(alice)
      expect(room.players).not_to include(alice)
    end
  end

  describe '#broadcast' do
    before do
      room.add_player(alice)
      room.add_player(bob)
    end

    it 'sends message to all players in room' do
      room.broadcast('Hello')
      expect(alice).to have_received(:puts).with('Hello')
      expect(bob).to have_received(:puts).with('Hello')
    end

    it 'excludes specified player' do
      room.broadcast('Hello', except: alice)
      expect(alice).not_to have_received(:puts)
      expect(bob).to have_received(:puts).with('Hello')
    end
  end
end
