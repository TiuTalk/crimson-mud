# frozen_string_literal: true

RSpec.shared_examples 'a registered command' do |keyword|
  it "registers as #{keyword}" do
    expect(Mud::Commands::Registry.lookup(keyword)).to eq(described_class)
  end
end
