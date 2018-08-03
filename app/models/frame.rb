# frozen_string_literal: true

class Frame < ApplicationRecord
  enum status: %i[open strike spare default]
  validates :status, :total_pins, presence: true
end
