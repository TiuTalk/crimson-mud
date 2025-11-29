# frozen_string_literal: true

RSpec.describe Mud::Server do
  subject(:server) { described_class.instance }

  after { server.players.clear }

  describe '.instance' do
    it { is_expected.to equal(described_class.instance) }
  end

  describe '#add_player' do
    let(:player) { instance_double(Mud::Player) }

    it 'adds to players set' do
      server.add_player(player)
      expect(server.players).to include(player)
    end
  end

  describe '#remove_player' do
    let(:player) { instance_double(Mud::Player) }

    it 'removes from players set' do
      server.add_player(player)
      server.remove_player(player)
      expect(server.players).not_to include(player)
    end
  end

  describe '#broadcast' do
    let(:alice) { instance_double(Mud::Player, name: 'Alice', puts: nil) }
    let(:bob) { instance_double(Mud::Player, name: 'Bob', puts: nil) }

    before do
      server.add_player(alice)
      server.add_player(bob)
    end

    it 'sends to all players except excluded' do
      server.broadcast('hello', except: alice)
      expect(alice).not_to have_received(:puts)
      expect(bob).to have_received(:puts).with('hello')
    end
  end

  describe '#handle_connection' do
    let(:socket) { instance_double(TCPSocket) }
    let(:client) { instance_double(Mud::Network::Client, puts: nil, close: nil, ip_address: '127.0.0.1') }

    before do
      allow(Mud::Network::Client).to receive(:new).and_return(client)
      allow(client).to receive(:gets).and_return("Alice\n", nil)
    end

    it 'creates player and runs until disconnect' do
      server.handle_connection(socket)
      expect(client).to have_received(:close)
    end

    it 'broadcasts arrived message excluding player' do
      allow(server).to receive(:broadcast) # rubocop:disable RSpec/SubjectStub
      server.handle_connection(socket)
      expect(server).to have_received(:broadcast).with('Alice arrived.', except: an_instance_of(Mud::Player)) # rubocop:disable RSpec/SubjectStub
    end

    it 'broadcasts left message on disconnect' do
      allow(server).to receive(:broadcast) # rubocop:disable RSpec/SubjectStub
      server.handle_connection(socket)
      expect(server).to have_received(:broadcast).with('Alice left.') # rubocop:disable RSpec/SubjectStub
    end
  end
end
