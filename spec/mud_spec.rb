# frozen_string_literal: true

RSpec.describe Mud do
  it 'has a version number' do
    expect(Mud::VERSION).not_to be_nil
  end

  describe '.logger' do
    after { described_class.logger = nil }

    it 'returns a Logger instance' do
      expect(described_class.logger).to be_a(Logger)
    end

    it 'allows setting a custom logger' do
      custom = Logger.new(nil)
      described_class.logger = custom
      expect(described_class.logger).to eq(custom)
    end
  end
end
