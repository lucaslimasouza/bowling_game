# frozen_string_literal: true

class Pitch < ApplicationRecord
  belongs_to :frame

  validates :pins_knocked_down, presence: true
  validates :pins_knocked_down, numericality: true
  validates :pins_knocked_down, numericality: { less_than_or_equal_to: 10 }

  def did_strike?
    pins_knocked_down == 10
  end
end
