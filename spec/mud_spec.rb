# frozen_string_literal: true

RSpec.describe Mud do
  it 'has a version number' do
    expect(Mud::VERSION).not_to be_nil
  end

  describe '.configuration' do
    subject { described_class.configuration }

    it { is_expected.to be_a(Mud::Configuration) }

    it 'returns same instance on multiple calls' do
      expect(described_class.configuration).to equal(described_class.configuration)
    end
  end

  describe '.logger' do
    subject { described_class.logger }

    it { is_expected.to eq(described_class.configuration.logger) }
  end
end
