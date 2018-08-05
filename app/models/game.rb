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
      previous_frame = get_previous_frame(index)

      if frame.spare? && next_frame
        bonus = pitches_bonus(frame, 1)
        frame_score = sum_score_to_frame(previous_frame, frame, bonus)
        frame.update_to_ends_status(frame_score)
        next
      end

      if frame.strike? && has_next_two_pitches?(frame)
        bonus = pitches_bonus(frame, 2)
        frame_score = sum_score_to_frame(previous_frame, frame, bonus)
        frame.update_to_ends_status(frame_score)
        next
      end

      if frame.open? && frame.is_second_pitch?
        frame_score = sum_score_to_frame(previous_frame, frame, 0)
        frame.update_to_ends_status(frame_score)
      end
    end

    self.score = frames.sum(&:score)
  end

  private

  def sum_score_to_frame(previous_frame, frame, bonus)
    total = frame.sum_score + bonus
    return total + previous_frame.score if previous_frame
    total
  end

  def pitches_bonus(frame, qty)
    result = get_first_pitches(frame, qty)
    return 0 if result.empty?
    result.sum(&:pins_knocked_down)
  end

  def get_first_pitches(frame, qty)
    pitches
      .where(game: self)
      .where('id > ? ', frame.pitches.last.id).first(qty)
  end

  def has_next_two_pitches?(frame)
    get_first_pitches(frame, 2).count == 2
  end

  def get_previous_frame(index)
    return nil if index == 0
    frames[index - 1]
  end
end
