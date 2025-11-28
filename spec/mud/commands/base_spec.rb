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
end
