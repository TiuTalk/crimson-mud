# frozen_string_literal: true

RSpec.describe Mud do
  it 'has a version number' do
    expect(Mud::VERSION).not_to be_nil
  end

  describe '.configuration' do
    it { expect(described_class.configuration).to be_a(Mud::Configuration) }

    it 'returns same instance' do
      expect(described_class.configuration).to equal(described_class.configuration)
    end
  end

  describe '.logger' do
    it 'delegates to configuration' do
      expect(described_class.logger).to equal(described_class.configuration.logger)
    end
  end
end
