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
  end
end
