# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::CommandRegistry do
  let(:player) { instance_double(Mud::Player, puts: nil) }

  describe '.parse' do
    it 'extracts command name and args' do
      expect(described_class.parse('say hello world')).to eq(['say', 'hello world'])
    end

    it 'downcases command name' do
      expect(described_class.parse('SAY hello')).to eq(['say', 'hello'])
    end

    it 'returns empty string for args when none given' do
      expect(described_class.parse('quit')).to eq(['quit', ''])
    end

    it 'handles nil input' do
      expect(described_class.parse(nil)).to eq([nil, ''])
    end
  end

  describe '.execute' do
    let(:server) { instance_double(Mud::Server, broadcast: nil) }

    before { allow(Mud::Server).to receive(:instance).and_return(server) }

    context 'with say command' do
      let(:player) { instance_double(Mud::Player, puts: nil, name: 'Alice') }

      it 'executes Say command' do
        described_class.execute('say hello', player:)
        expect(player).to have_received(:puts).with("You say, 'hello'")
      end
    end

    context 'with quit command' do
      let(:player) { instance_double(Mud::Player, quit: nil) }

      it 'executes Quit command' do
        described_class.execute('quit', player:)
        expect(player).to have_received(:quit)
      end
    end

    context 'with unknown command' do
      it 'executes Unknown command' do
        described_class.execute('foobar', player:)
        expect(player).to have_received(:puts).with('Unknown command: foobar')
      end
    end
  end
end
