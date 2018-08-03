# frozen_string_literal: true

class Pitch < ApplicationRecord
  belongs_to :frame

  validates :pins_knocked_down, presence: true

  def did_strike?
    pins_knocked_down == 10
  end
end
