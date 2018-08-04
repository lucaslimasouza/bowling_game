# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pitch, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :pins_knocked_down }

    it { is_expected.to belong_to :frame }

    it { is_expected.to validate_numericality_of :pins_knocked_down }

    it {
      is_expected.to validate_numericality_of(:pins_knocked_down)
        .is_less_than_or_equal_to(10)
    }
  end

  describe '#did_strike' do
    it 'is truthy when 10 pins was knocked down' do
      expect(subject.did_strike?).to be_falsy
    end

    it 'is truthy when 10 pins was knocked down' do
      pitch = build(:pitch, pins_knocked_down: 10)
      expect(pitch.did_strike?).to be_truthy
    end
  end
end
