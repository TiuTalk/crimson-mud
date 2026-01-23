# frozen_string_literal: true

RSpec.describe Mud::Commands::Tell do
  subject(:command) { described_class.new(player: alice, args:) }

  let(:alice) { instance_double(Mud::Player, puts: nil, name: 'Alice') }
  let(:bob) { instance_double(Mud::Player, puts: nil, name: 'Bob') }
  let(:args) { 'Bob hello there' }

  before do
    allow(Mud.world).to receive(:players) do |except: nil|
      [alice, bob].reject { |p| p == except }
    end
  end

  it_behaves_like 'a registered command', 'tell'

  describe '#validate' do
    it { is_expected.to have_attributes(validate: nil) }

    context 'when target not found' do
      let(:args) { 'Charlie hello' }

      it { is_expected.to have_attributes(validate: 'No player by that name is connected.') }
    end

    context 'when telling self' do
      let(:args) { 'Alice hello' }

      it { is_expected.to have_attributes(validate: 'No player by that name is connected.') }
    end

    context 'with case-insensitive name' do
      let(:args) { 'bob test' }

      it { is_expected.to have_attributes(validate: nil) }
    end
  end

  describe '#perform' do
    before { allow(Mud::Actions::Tell).to receive(:execute) }

    it 'delegates to Actions::Tell' do
      command.perform
      expect(Mud::Actions::Tell).to have_received(:execute).with(actor: alice, target: bob, message: 'hello there')
    end

    context 'with color codes in message' do
      let(:args) { 'Bob &rhello' }

      it 'strips color codes' do
        command.perform
        expect(Mud::Actions::Tell).to have_received(:execute).with(actor: alice, target: bob, message: 'hello')
      end
    end
  end
end
