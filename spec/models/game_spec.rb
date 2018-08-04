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
end
