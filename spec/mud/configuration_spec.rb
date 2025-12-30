# frozen_string_literal: true

RSpec.describe Mud::Configuration do
  subject(:config) { described_class.new }

  describe '#logger' do
    subject { config.logger }

    it { is_expected.to be_a(Logger) }
  end

  describe '#logger=' do
    it 'sets custom logger' do
      new_logger = Logger.new(nil)
      config.logger = new_logger
      expect(config.logger).to eq(new_logger)
    end
  end
end
