# frozen_string_literal: true

class Frame < ApplicationRecord
  enum status: %i[open strike spare ends]
  has_many :pitches, dependent: :destroy
  belongs_to :game

  validates :status, :total_pins, presence: true
  validates :pitches, length: { maximum: 2 }, if: :is_not_tenth_frame
  validates :total_pins, :score, numericality: true
  validate :maximum_pins_knocked_down, if: :is_not_tenth_frame

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
    self.total_pins -= sum_pins_last_pitches
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

  def is_not_tenth_frame
    Frame.where(game_id: game.id).count < 10 if game
  end

  def sum_pins_last_pitches
    sum = pitches.last(2).sum(&:pins_knocked_down)
    return 10 if sum > 10
    sum
  end
end
