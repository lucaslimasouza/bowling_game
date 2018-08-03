# frozen_string_literal: true

class Frame < ApplicationRecord
  enum status: %i[open strike spare default]
  has_many :pitches, dependent: :destroy

  validates :status, :total_pins, presence: true
  validates :pitches, length: { maximum: 2 }
end
