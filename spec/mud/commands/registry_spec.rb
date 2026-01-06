# frozen_string_literal: true

RSpec.describe Mud::Commands::Registry do
  let(:command) { Class.new(Mud::Commands::Base) }

  after { described_class.unregister(:test, :t) }

  describe '.register' do
    it 'stores keyword to class mapping' do
      described_class.register(:test, command)
      expect(described_class.lookup('test')).to eq(command)
    end

    context 'with multiple keywords' do
      it 'registers all keywords' do
        described_class.register(:test, :t, command)
        expect(described_class.lookup('test')).to eq(command)
        expect(described_class.lookup('t')).to eq(command)
      end
    end
  end

  describe '.lookup' do
    it 'returns nil for unknown keyword' do
      expect(described_class.lookup('unknown')).to be_nil
    end

    it 'returns registered class' do
      described_class.register(:test, command)
      expect(described_class.lookup('test')).to eq(command)
    end

    context 'with abbreviations' do
      let(:loot_command) { Class.new(Mud::Commands::Base) }

      before { described_class.register(:loot, loot_command) }
      after { described_class.unregister(:loot) }

      it { expect(described_class.lookup('look')).to eq(Mud::Commands::Look) }
      it { expect(described_class.lookup('loot')).to eq(loot_command) }
      it { expect(described_class.lookup('loo')).to be_nil }
    end

    context 'with exact match over abbreviation' do
      let(:loot_command) { Class.new(Mud::Commands::Base) }
      let(:loo_command) { Class.new(Mud::Commands::Base) }

      before do
        described_class.register(:loot, loot_command)
        described_class.register(:loo, loo_command)
      end

      after { described_class.unregister(:loot, :loo) }

      it { expect(described_class.lookup('loo')).to eq(loo_command) }
    end
  end

  describe '.unregister' do
    it 'removes single registration' do
      described_class.register(:test, command)
      described_class.unregister(:test)
      expect(described_class.lookup('test')).to be_nil
    end
  end

  describe '.keywords' do
    before { described_class.register(:test, :t, command) }

    it 'returns sorted registered keywords' do
      expect(described_class.keywords).to include(:t, :test)
    end
  end
end
