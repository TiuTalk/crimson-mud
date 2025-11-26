# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Network::Client do
  subject(:client) { described_class.new(socket) }

  let(:socket) { instance_double(TCPSocket) }

  describe '#handle' do
    before do
      allow(socket).to receive(:puts)
      allow(socket).to receive(:close)
    end

    it 'echoes each line back to client' do
      allow(socket).to receive(:gets).and_return("hello\n", "world\n", nil)

      client.handle

      expect(socket).to have_received(:puts).with("hello\n").ordered
      expect(socket).to have_received(:puts).with("world\n").ordered
    end

    it 'closes socket on disconnect' do
      allow(socket).to receive(:gets).and_return(nil)

      client.handle

      expect(socket).to have_received(:close)
    end
  end
end
