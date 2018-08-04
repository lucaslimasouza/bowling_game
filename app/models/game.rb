class Game < ApplicationRecord
  has_many :frames, dependent: :destroy

  validates :user_name, presence: true
  validates :user_name, length: { maximum: 20 }
  validates :score, numericality: { less_than_or_equal_to: 300 }
  validates :frames, length: { maximum: 10 }

  before_save :update_frame_with_strike

  def current_frame
    frames
      .where(status: Frame.statuses['open'], score: 0)
      .first_or_initialize
  end

  def update_frame_with_strike
    score ||= 0

    frames.each_with_index do |frame, index|
      next_frame = frames[index + 1]
      previous_frame = frames[index - 1]
      if frame.strike? && next_frame && next_frame.ends?
        frame.score = frame.sum_score + next_frame.sum_score
        frame.status = Frame.statuses['ends']
        frame.save
      elsif frame.spare? && next_frame && next_frame.is_first_pitch?
        frame.score = sum_score_to_frame(previous_frame, frame, next_frame)
        frame.status = Frame.statuses['ends']
        frame.save
      end
    end
    self.score = frames.sum(&:score)
  end

  private

  def sum_score_to_frame(previous_frame, frame, next_frame)
    total = frame.sum_score + next_frame.sum_score
    return total + previous_frame.score if previous_frame
    total
  end
end
