# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Commands::Quit do
  subject(:command) { described_class.new(player:, args:) }

  let(:player) { instance_double(Mud::Player, quit: nil) }
  let(:args) { '' }

  it 'inherits from Base' do
    expect(described_class).to be < Mud::Commands::Base
  end

  describe '#perform' do
    it 'quits player' do
      expect(player).to receive(:quit)
      command.perform
    end
  end
end
