# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Sanitizer do
  describe '.strip_ansi' do
    subject { described_class.strip_ansi(text) }

    context 'with nil' do
      let(:text) { nil }

      it { is_expected.to be_nil }
    end

    context 'with empty string' do
      let(:text) { '' }

      it { is_expected.to eq('') }
    end

    context 'without ANSI codes' do
      let(:text) { 'hello world' }

      it { is_expected.to eq('hello world') }
    end

    context 'with color ANSI codes' do
      it { expect(described_class.strip_ansi("\e[31mred")).to eq('red') }
      it { expect(described_class.strip_ansi("\e[1;31mbold")).to eq('bold') }
    end

    context 'with cursor/screen ANSI codes' do
      it { expect(described_class.strip_ansi("\e[2J")).to eq('') }
      it { expect(described_class.strip_ansi("\e[H")).to eq('') }
      it { expect(described_class.strip_ansi("\e[?25l")).to eq('') }
    end

    context 'with OSC sequences' do
      it { expect(described_class.strip_ansi("\e]0;evil\a")).to eq('') }
    end

    context 'with &X color codes (preserved)' do
      let(:text) { '&rhello' }

      it { is_expected.to eq('&rhello') }
    end
  end
end
