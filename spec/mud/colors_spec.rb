# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Colors do
  describe '.parse' do
    subject { described_class.parse(text) }

    context 'without color codes' do
      let(:text) { 'hello world' }

      it { is_expected.to eq('hello world') }
    end

    context 'with empty string' do
      let(:text) { '' }

      it { is_expected.to eq('') }
    end

    context 'with dark colors' do
      let(:text) { '&rhello' }

      it { is_expected.to eq("\e[31mhello\e[0m") }
    end

    context 'with bright colors' do
      let(:text) { '&Rhello' }

      it { is_expected.to eq("\e[91mhello\e[0m") }
    end

    context 'with multiple colors' do
      let(:text) { '&rhello &bworld' }

      it { is_expected.to eq("\e[31mhello \e[34mworld\e[0m") }
    end

    context 'with escaped ampersand' do
      it { expect(described_class.parse('&&')).to eq('&') }
      it { expect(described_class.parse('Tom && Jerry')).to eq('Tom & Jerry') }
      it { expect(described_class.parse('&r&&')).to eq("\e[31m&\e[0m") }
    end

    context 'with invalid codes' do
      it { expect(described_class.parse('&')).to eq('&') }
      it { expect(described_class.parse('&x')).to eq('&x') }
      it { expect(described_class.parse('&1')).to eq('&1') }
    end

    context 'with consecutive color codes' do
      it { expect(described_class.parse('&R&bhi')).to eq("\e[34mhi\e[0m") }
      it { expect(described_class.parse('&R&b&ghi')).to eq("\e[32mhi\e[0m") }
      it { expect(described_class.parse('&rhello &R&bworld')).to eq("\e[31mhello \e[34mworld\e[0m") }
    end

    context 'with only escapes or invalid codes' do
      it { expect(described_class.parse('hello && &x')).to eq('hello & &x') }
    end

    context 'with trailing newlines' do
      it { expect(described_class.parse("&rhello\n")).to eq("\e[31mhello\e[0m\n") }
      it { expect(described_class.parse("&rhello\r\n")).to eq("\e[31mhello\e[0m\r\n") }
      it { expect(described_class.parse("&rhello\n\n")).to eq("\e[31mhello\e[0m\n\n") }
      it { expect(described_class.parse('&rhello')).to eq("\e[31mhello\e[0m") }
      it { expect(described_class.parse("&rhello\nworld")).to eq("\e[31mhello\nworld\e[0m") }
    end
  end
end
