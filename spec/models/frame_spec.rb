# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe 'validations' do
    %i[status total_pins].each do |field|
      it { is_expected.to validate_presence_of field }
    end

    it { is_expected.to have_many(:pitches).dependent(:destroy) }

    it 'have max two Pitches' do
      frame = build(:frame)

      frame.pitches = build_list(:pitch, 3)
      expect(frame.valid?).to be_falsy

      frame.pitches = build_list(:pitch, 2)
      expect(frame.valid?).to be_truthy
    end
  end
end
