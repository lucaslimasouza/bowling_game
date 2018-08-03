# frozen_string_literal: true

class Frame < ApplicationRecord
  enum status: %i[open strike spare default]
  has_many :pitches, dependent: :destroy

  validates :status, :total_pins, presence: true
  validates :pitches, length: { maximum: 2 }

  before_save :set_up_status

  def set_up_status
    self.status = Frame.statuses['strike'] if pitches.length == 1 && pitches.first.pins_knocked_down == 10
  end
end
