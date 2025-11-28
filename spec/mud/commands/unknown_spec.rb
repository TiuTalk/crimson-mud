# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Commands::Unknown do
  subject(:command) { described_class.new(player:, args:, name:) }

  let(:player) { instance_double(Mud::Player, puts: nil) }
  let(:args) { '' }
  let(:name) { 'foobar' }

  it 'inherits from Base' do
    expect(described_class).to be < Mud::Commands::Base
  end

  describe '#execute' do
    it 'tells player command is unknown' do
      command.execute
      expect(player).to have_received(:puts).with("Unknown command: foobar")
    end
  end
end
