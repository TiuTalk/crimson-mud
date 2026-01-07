# frozen_string_literal: true

RSpec.describe Mud::Room do
  subject(:room) { described_class.new(name: 'Town Square', description: 'A bustling square.') }

  let(:alice) { instance_double(Mud::Player, puts: nil) }
  let(:bob) { instance_double(Mud::Player, puts: nil) }

  it_behaves_like 'has players'

  describe '#name' do
    it { expect(room.name).to eq('Town Square') }
  end

  describe '#description' do
    it { expect(room.description).to eq('A bustling square.') }
  end

  describe '.starting' do
    it { expect(described_class.starting.name).to eq('The Void') }
  end
end
