# frozen_string_literal: true

RSpec.describe Mud::Actions::Say do
  subject(:execute) { described_class.execute(actor:, message:) }

  let(:room) { instance_double(Mud::Room, broadcast: nil) }
  let(:actor) { instance_double(Mud::Player, puts: nil, name: 'Alice', room:) }
  let(:message) { 'hello world' }

  it 'echoes to actor and broadcasts to room' do
    execute
    expect(actor).to have_received(:puts).with("&cYou say 'hello world'")
    expect(room).to have_received(:broadcast).with("&cAlice says 'hello world'", except: actor)
  end
end
