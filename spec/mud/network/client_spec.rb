# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Mud::Network::Client do
  subject(:client) { described_class.new(socket:, server:) }

  let(:socket) { instance_double(TCPSocket, puts: nil, close: nil, peeraddr:) }
  let(:peeraddr) { ['AF_INET', 1234, 'localhost', '192.168.1.100'] }
  let(:server) { instance_double(Mud::Network::Server, add_client: nil, remove_client: nil, broadcast: nil) }

  describe '#handle' do
    before do
      allow(socket).to receive(:gets).and_return("Alice\n", nil)
      allow(Mud.logger).to receive(:info)
    end

    it 'adds client to server on start' do
      client.handle

      expect(server).to have_received(:add_client).with(client)
    end

    it 'removes client from server on disconnect' do
      client.handle

      expect(server).to have_received(:remove_client).with(client)
    end

    it 'sends welcome message' do
      client.handle

      expect(socket).to have_received(:puts).with('Welcome to Crimson MUD!')
    end

    it 'prompts for name' do
      client.handle

      expect(socket).to have_received(:puts).with('What is your name?')
    end

    it 'stores name' do
      client.handle

      expect(client.name).to eq('Alice')
    end

    it 'logs connected with name' do
      client.handle

      expect(Mud.logger).to have_received(:info).with('Alice connected (192.168.1.100)')
    end

    it 'logs disconnected with name' do
      client.handle

      expect(Mud.logger).to have_received(:info).with('Alice disconnected (192.168.1.100)')
    end

    it 're-prompts on empty name' do
      allow(socket).to receive(:gets).and_return("\n", "Alice\n", nil)

      client.handle

      expect(socket).to have_received(:puts).with('What is your name?').twice
    end

    it 're-prompts on whitespace-only name' do
      allow(socket).to receive(:gets).and_return("   \n", "Alice\n", nil)

      client.handle

      expect(socket).to have_received(:puts).with('What is your name?').twice
    end

    it 'closes socket on disconnect' do
      allow(socket).to receive(:gets).and_return(nil)

      client.handle

      expect(socket).to have_received(:close)
    end

    context 'when receiving messages' do
      before { allow(socket).to receive(:gets).and_return("Alice\n", "hello\n", nil) }

      it 'sends "You say" to self' do
        client.handle

        expect(socket).to have_received(:puts).with("You say, 'hello'")
      end

      it 'broadcasts "Name says" to others' do
        client.handle

        expect(server).to have_received(:broadcast).with("Alice says, 'hello'", except: client)
      end
    end
  end

  describe '#puts' do
    it 'delegates to socket' do
      client.puts('hello')

      expect(socket).to have_received(:puts).with('hello')
    end
  end
end
