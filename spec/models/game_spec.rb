require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :user_name }
    it { is_expected.to validate_numericality_of :score }
  end
end
