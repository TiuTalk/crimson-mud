# frozen_string_literal: true

RSpec.describe Mud::Commands::Processor do
  subject(:processor) { described_class.new(player:) }

  let(:player) { instance_double(Mud::Player, puts: nil, quit: nil) }
  let(:server) { instance_double(Mud::Telnet::Server, broadcast: nil) }

  before { allow(Mud).to receive(:server).and_return(server) }

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

      it 'broadcasts to others' do
        processor.process('say hello world')
        expect(server).to have_received(:broadcast).with("&cSomeone says 'hello world'", except: player)
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
