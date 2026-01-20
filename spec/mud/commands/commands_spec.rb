# frozen_string_literal: true

RSpec.describe Mud::Commands::Commands do
  subject(:command) { described_class.new(player:) }

  let(:player) { instance_double(Mud::Player, puts: nil) }

  it_behaves_like 'a registered command', 'commands'

  describe '#perform' do
    let(:keywords) { %i[a bb ccc dddd e f g h] }
    let(:expected) do
      <<~OUTPUT.chomp
        Available commands:
        a        bb       ccc      dddd
        e        f        g        h
      OUTPUT
    end

    before { allow(Mud::Commands::Registry).to receive(:keywords).and_return(keywords) }

    it 'lists commands in 4-column format with padding' do
      command.perform
      expect(player).to have_received(:puts).with(expected)
    end
  end
end
