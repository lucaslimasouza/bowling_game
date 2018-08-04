# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe 'validations' do
    %i[status total_pins].each do |field|
      it { is_expected.to validate_presence_of field }
    end

    %i[total_pins score].each do |field|
      it { is_expected.to validate_numericality_of field }
    end

    it { is_expected.to have_many(:pitches).dependent(:destroy) }

    it 'have maximum two Pitches' do
      frame = build(:frame)

      frame.pitches = build_list(:pitch, 3)
      expect(frame.valid?).to be_falsy

      frame.pitches = build_list(:pitch, 2)
      expect(frame.valid?).to be_truthy
    end

    it 'has maximum 10 pins knocked down' do
      frame = create(:frame)

      frame.pitches << build(:pitch, pins_knocked_down: 6)
      expect(frame.valid?).to be_truthy

      frame.pitches << build(:pitch, pins_knocked_down: 10)
      expect(frame.valid?).to be_falsy
    end
  end

  describe '#status' do
    subject { create(:frame) }

    context 'strike' do
      it 'is when first Pitch has 10 pins knocked down' do
        subject.pitches.build(attributes_for(:pitch, pins_knocked_down: 10))
        subject.save

        expect(subject.strike?).to be_truthy
        expect(subject.score).to eq 0
      end
    end

    context 'spare' do
      it 'is when all Pitches has 10 pins knocked down' do
        pitches = build_list(:pitch, 2, pins_knocked_down: 5)
        subject.pitches = pitches
        subject.save

        expect(subject.spare?).to be_truthy
        expect(subject.score).to eq 0
      end
    end

    context 'ends' do
      it 'is when all Pitches has less than 10 pins knocked down' do
        pitches = build_list(:pitch, 2, pins_knocked_down: 4)
        subject.pitches = pitches
        subject.save

        expect(subject.ends?).to be_truthy
        # TODO: fix the score afte game be defined
        expect(subject.score).to eq 8
      end
    end
  end
end
