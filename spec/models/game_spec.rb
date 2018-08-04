require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :user_name }

    it { is_expected.to validate_length_of(:user_name).is_at_most(20) }

    it { is_expected.to validate_numericality_of :score }

    it {
      is_expected.to validate_numericality_of(:score)
        .is_less_than_or_equal_to(300)
    }

    it { is_expected.to have_many(:frames).dependent(:destroy) }

    it 'has maximum 10 Frames' do
      game = create(:game)

      game.frames = build_list(:frame, 9)
      expect(game.valid?).to be_truthy

      game.frames << build_list(:frame, 2)
      expect(game.valid?).to be_falsy
    end
  end

  describe '#frames' do
    subject { create(:game) }

    context 'strike' do
      before(:each) do
        frame = subject.current_frame
        frame.pitches.build(pins_knocked_down: 10)
        frame.save
      end

      it 'has one Frame with strike and score 0' do
        expect(subject.frames.last.strike?).to be_truthy
        expect(subject.score).to eq 0
      end

      it "update Frame's score after 2 Pitches" do
        frame = subject.current_frame
        frame.save
        frame.pitches.create(pins_knocked_down: 3)

        frame = subject.current_frame
        frame.pitches.create(pins_knocked_down: 6)
        frame.save

        subject.save
        first_frame = subject.frames.first

        expect(first_frame.ends?).to be_truthy
        expect(first_frame.score).to eq 19
        expect(subject.score).to eq 28
      end
    end
  end
end
