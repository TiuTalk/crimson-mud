# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Commands::Base do
  subject(:command) { described_class.new(player:, args:) }

  let(:player) { instance_double(Mud::Player) }
  let(:args) { 'some arguments' }

  describe '#execute' do
    it 'raises NotImplementedError' do
      expect { command.execute }.to raise_error(NotImplementedError)
    end
  end

  describe '.command' do
    let(:test_class) { Class.new(described_class) }

    before { allow(Mud::CommandRegistry).to receive(:register) }

    it 'registers command with registry' do
      test_class.command(:look, aliases: %i[l])
      expect(Mud::CommandRegistry).to have_received(:register).with(test_class, :look, aliases: %i[l])
    end
  end
end
