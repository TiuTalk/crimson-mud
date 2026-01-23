# frozen_string_literal: true

RSpec.describe Mud::Actions::Base do
  subject(:action) { described_class.new(actor: player) }

  let(:room) { instance_double(Mud::Room) }
  let(:player) { instance_double(Mud::Player, room:) }

  describe '.execute' do
    let(:test_class) do
      Class.new(described_class) { def perform(message:) = message.upcase }
    end

    it 'delegates to instance #perform with args' do
      expect(test_class.execute(actor: player, message: 'hello')).to eq('HELLO')
    end
  end

  describe '#room' do
    it 'returns actor.room' do
      expect(action.send(:room)).to eq(room)
    end
  end
end
