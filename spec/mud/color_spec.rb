# frozen_string_literal: true

RSpec.describe Mud::Color do
  describe '.colorize' do
    subject { described_class.colorize(text) }

    context 'with empty string' do
      let(:text) { '' }

      it { is_expected.to eq '' }
    end

    context 'with no color codes' do
      let(:text) { 'Hello world' }

      it { is_expected.to eq 'Hello world' }
    end

    context 'with single dark red code' do
      let(:text) { '&rHello' }

      it { is_expected.to eq "\e[31mHello\e[0m" }
    end

    context 'with multiple codes' do
      let(:text) { '&RHello &Gworld' }

      it { is_expected.to eq "\e[91mHello \e[92mworld\e[0m" }
    end

    context 'with reset code' do
      let(:text) { '&RHello&n world' }

      it { is_expected.to eq "\e[91mHello\e[0m world\e[0m" }
    end

    context 'with escaped ampersand' do
      let(:text) { '&&rHello' }

      it { is_expected.to eq '&rHello' }
    end

    context 'with escaped and real code' do
      let(:text) { '&&r is &Rred' }

      it { is_expected.to eq "&r is \e[91mred\e[0m" }
    end

    context 'with sequential codes' do
      let(:text) { '&r&g&bBlue' }

      it { is_expected.to eq "\e[34mBlue\e[0m" }
    end
  end

  describe '.strip' do
    it 'removes color codes and converts escaped ampersands' do
      expect(described_class.strip('&rRed && &gGreen')).to eq 'Red & Green'
    end

    it 'returns unchanged text without ampersands' do
      expect(described_class.strip('Hello world')).to eq 'Hello world'
    end
  end
end
