# frozen_string_literal: true

RSpec.describe Mud::Commands::Say do
  subject(:command) { described_class.new(player:, args:) }

  let(:room) { instance_double(Mud::Room, broadcast: nil) }
  let(:player) { instance_double(Mud::Player, puts: nil, name: 'Alice', room:) }
  let(:args) { 'hello' }

  it_behaves_like 'a registered command', 'say'

  describe '#perform' do
    it 'echoes to player and broadcasts to room' do
      command.perform
      expect(player).to have_received(:puts).with("&cYou say 'hello'")
      expect(room).to have_received(:broadcast).with("&cAlice says 'hello'", except: player)
    end

    context 'with color codes in message' do
      let(:args) { '&rhello' }

      it 'strips color codes' do
        command.perform
        expect(player).to have_received(:puts).with("&cYou say 'hello'")
      end
    end
  end
end
