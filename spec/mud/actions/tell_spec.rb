# frozen_string_literal: true

RSpec.describe Mud::Actions::Tell do
  subject(:execute) { described_class.execute(actor: alice, target: bob, message:) }

  let(:alice) { instance_double(Mud::Player, puts: nil, name: 'Alice') }
  let(:bob) { instance_double(Mud::Player, puts: nil, name: 'Bob') }
  let(:message) { 'hello there' }

  it 'sends messages to both actor and target' do
    execute
    expect(alice).to have_received(:puts).with("&mYou tell Bob, 'hello there'")
    expect(bob).to have_received(:puts).with("&mAlice tells you, 'hello there'")
  end
end
