# frozen_string_literal: true

RSpec.describe Mud::Commands::Processor do
  subject(:processor) { described_class.new(player:) }

  let(:room) { instance_double(Mud::Room, broadcast: nil) }
  let(:player) { instance_double(Mud::Player, puts: nil, quit: nil, name: 'Alice', room:) }
  let(:logger) { instance_double(Logger, debug: nil) }

  before { allow(Mud).to receive(:logger).and_return(logger) }

  describe '#process' do
    context 'with quit command' do
      it 'calls player.quit' do
        processor.process('quit')
        expect(player).to have_received(:quit)
      end
    end

    context 'with say command' do
      it 'tells speaker what they said' do
        processor.process('say hello world')
        expect(player).to have_received(:puts).with("&cYou say 'hello world'")
      end

      it 'broadcasts to room with player name' do
        processor.process('say hello world')
        expect(room).to have_received(:broadcast).with("&cAlice says 'hello world'", except: player)
      end
    end

    context 'with unknown command' do
      it 'shows error message' do
        processor.process('foo bar')
        expect(player).to have_received(:puts).with('Unknown command: foo')
      end
    end
  end
end
