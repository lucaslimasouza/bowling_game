# frozen_string_literal: true

class Frame < ApplicationRecord
  enum status: %i[open strike spare default]
  has_many :pitches, dependent: :destroy

  validates :status, :total_pins, presence: true
  validates :pitches, length: { maximum: 2 }

  before_save :set_up_status

  def set_up_status
    if is_first_pitch? && pitches.first.did_strike?
      self.status = Frame.statuses['strike']
    end
  end

  private

  def is_first_pitch?
    pitches.length == 1
  end
end
