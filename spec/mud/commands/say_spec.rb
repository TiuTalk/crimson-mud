# frozen_string_literal: true

RSpec.describe Mud::Commands::Say do
  subject(:command) { described_class.new(player:, args:) }

  let(:room) { instance_double(Mud::Room, broadcast: nil) }
  let(:player) { instance_double(Mud::Player, puts: nil, name: 'Alice', room:) }
  let(:args) { 'hello' }

  it_behaves_like 'a registered command', 'say'

  describe '#validate' do
    it { is_expected.to have_attributes(validate: nil) }

    context 'when message is empty' do
      let(:args) { '' }

      it { is_expected.to have_attributes(validate: 'What do you want to say?') }
    end
  end

  describe '#perform' do
    before { allow(Mud::Actions::Say).to receive(:execute) }

    it 'delegates to Actions::Say' do
      command.perform
      expect(Mud::Actions::Say).to have_received(:execute).with(actor: player, message: 'hello')
    end

    context 'with color codes in message' do
      let(:args) { '&rhello' }

      it 'strips color codes' do
        command.perform
        expect(Mud::Actions::Say).to have_received(:execute).with(actor: player, message: 'hello')
      end
    end
  end
end
