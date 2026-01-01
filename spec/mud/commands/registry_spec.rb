# frozen_string_literal: true

RSpec.describe Mud::Commands::Registry do
  after { described_class.unregister(:test) }

  describe '.register' do
    it 'stores keyword as string to class mapping' do
      described_class.register(:test, String)
      expect(described_class.lookup('test')).to eq(String)
    end
  end

  describe '.lookup' do
    it 'returns nil for unknown keyword' do
      expect(described_class.lookup('unknown')).to be_nil
    end

    it 'returns registered class' do
      described_class.register(:test, Integer)
      expect(described_class.lookup('test')).to eq(Integer)
    end
  end

  describe '.unregister' do
    it 'removes single registration' do
      described_class.register(:test, String)
      described_class.unregister(:test)
      expect(described_class.lookup('test')).to be_nil
    end
  end
end
