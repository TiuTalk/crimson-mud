# frozen_string_literal: true

RSpec.describe Mud::Commands::Look do
  subject(:command) { described_class.new(player:) }

  let(:room) { instance_double(Mud::Room, name: 'Test Room', description: 'A test description.', players: players_in_room) }
  let(:player) { instance_double(Mud::Player, room:, puts: nil, name: 'Alice') }
  let(:players_in_room) { Set.new }

  it_behaves_like 'a registered command', 'look'

  describe '#perform' do
    it 'outputs room name and description' do
      command.perform
      expect(player).to have_received(:puts).with("&cTest Room&n\nA test description.")
    end

    context 'with other players in room' do
      let(:bob) { instance_double(Mud::Player, name: 'Bob') }
      let(:players_in_room) { Set[bob] }

      it 'includes other players in output' do
        command.perform
        expect(player).to have_received(:puts).with("&cTest Room&n\nA test description.\n&yBob is here.")
      end
    end
  end
end
