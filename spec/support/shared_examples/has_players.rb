# frozen_string_literal: true

RSpec.shared_examples 'has players' do
  describe '#players' do
    it { expect(subject.players).to be_an(Array) }
    it { expect(subject.players).to be_empty }

    context 'with except:' do
      before do
        subject.add_player(alice)
        subject.add_player(bob)
      end

      it 'excludes specified player' do
        expect(subject.players(except: alice)).to eq([bob])
      end
    end
  end

  describe '#add_player' do
    it 'adds player' do
      subject.add_player(alice)
      expect(subject.players).to include(alice)
    end
  end

  describe '#remove_player' do
    before { subject.add_player(alice) }

    it 'removes player' do
      subject.remove_player(alice)
      expect(subject.players).not_to include(alice)
    end
  end

  describe '#broadcast' do
    before do
      subject.add_player(alice)
      subject.add_player(bob)
    end

    it 'sends message to all players' do
      subject.broadcast('Hello')
      expect(alice).to have_received(:puts).with('Hello')
      expect(bob).to have_received(:puts).with('Hello')
    end

    it 'excludes specified player' do
      subject.broadcast('Hello', except: alice)
      expect(alice).not_to have_received(:puts)
      expect(bob).to have_received(:puts).with('Hello')
    end
  end
end
