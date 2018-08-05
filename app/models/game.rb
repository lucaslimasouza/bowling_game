class Game < ApplicationRecord
  has_many :frames, dependent: :destroy
  has_many :pitches

  validates :user_name, presence: true
  validates :user_name, length: { maximum: 20 }
  validates :score, numericality: { less_than_or_equal_to: 300 }
  validates :frames, length: { maximum: 10 }

  before_save :update_frames

  def current_frame
    frames
      .where(status: Frame.statuses['open'], score: 0)
      .first_or_initialize
  end

  def update_frames
    frames.each_with_index do |frame, index|
      next_frame = frames[index + 1]
      previous_frame = frames[index - 1]
      if frame.spare? && next_frame
        frame_score = sum_score_to_frame(previous_frame, frame, 1)
        frame.update_to_ends_status(frame_score)
      end
    end
    self.score = frames.sum(&:score)
  end

  private

  def sum_score_to_frame(previous_frame, frame, bonus)
    total = frame.sum_score + pitches_bonus(frame, bonus)
    return total + previous_frame.score if previous_frame
    total
  end

  def pitches_bonus(frame, qty)
    result = pitches
             .where(game: self)
             .where('id > ? ', frame.pitches.last.id).first(qty)

    return result.sum(&:pins_knocked_down) unless result.empty?
    0
  end
end
