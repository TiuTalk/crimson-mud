# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Network::Telnet do
  describe '::PROMPT_MARKER' do
    it { expect(described_class::PROMPT_MARKER).to eq("\xFF\xF9\xFF\xEF") }
    it { expect(described_class::PROMPT_MARKER).to be_frozen }
  end
end
