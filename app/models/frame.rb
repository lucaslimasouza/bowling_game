# frozen_string_literal: true

class Frame < ApplicationRecord
  enum status: %i[open strike spare ends]
  has_many :pitches, dependent: :destroy
  belongs_to :game

  validates :status, :total_pins, presence: true
  validates :pitches, length: { maximum: 2 }
  validates :total_pins, :score, numericality: true
  validate :maximum_pins_knocked_down

  before_save :set_up_status

  def set_up_status
    self.score = score || 0
    if is_strike?
      self.status = Frame.statuses['strike']
    elsif is_spare?
      self.status = Frame.statuses['spare']
    end
  end

  def sum_score
    pitches.sum(&:pins_knocked_down)
  end

  def is_second_pitch?
    pitches.length == 2
  end

  def update_to_ends_status(bonus)
    self.score = bonus
    self.total_pins -= sum_score
    self.status = Frame.statuses['ends']
    save
  end

  private

  def is_strike?
    is_first_pitch? && pitches.first.did_strike? && open?
  end

  def is_spare?
    pitches.sum(&:pins_knocked_down) == 10 && open?
  end

  def is_first_pitch?
    pitches.length == 1
  end

  def maximum_pins_knocked_down
    if pitches.sum(&:pins_knocked_down) > 10 && pitches.length == 2
      errors.add(:pitches, "can't has more then 10 pins knocked down")
    end
  end
end
