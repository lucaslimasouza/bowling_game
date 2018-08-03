# frozen_string_literal: true

class Pitch < ApplicationRecord
  belongs_to :frame

  validates :pins_knocked_down, presence: true
end
