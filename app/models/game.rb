class Game < ApplicationRecord
  SPARE_BONUS_PITCH = 1
  STRIKE_BONUS_PITCHES = 2
  DEFAULT_BONUS_PITCH = 0
  TENTH_FRAME_PITCHES = 3

  has_many :frames, dependent: :destroy
  has_many :pitches

  enum status: %i[open ends]

  validates :user_name, presence: true
  validates :user_name, length: { maximum: 20 }
  validates :score, numericality: true
  validates :frames, length: { maximum: 10 }

  before_save :update_frames, :update_status

  def current_frame
    return frames.last if frames.count == 10
    frames
      .where(status: Frame.statuses['open'], score: 0)
      .first_or_initialize
  end

  def update_frames
    frames.each_with_index do |frame, index|
      run_spare_rule(frame, index)
      run_strike_rule(frame, index)
      run_default_rule(frame, index)
    end

    self.score = frames.sum(&:score)
  end

  private

  def run_spare_rule(frame, index)
    if frame.spare? && (
      has_next_pitches?(frame, SPARE_BONUS_PITCH) ||
      is_last_frame_with_bonus(frame, TENTH_FRAME_PITCHES)
    )
      bonus = pitches_bonus(frame, SPARE_BONUS_PITCH)
      set_score_to_frame(frame, bonus, index)
    end
  end

  def run_strike_rule(frame, index)
    if frame.strike? && (
      has_next_pitches?(frame, STRIKE_BONUS_PITCHES) ||
      is_last_frame_with_bonus(frame, TENTH_FRAME_PITCHES)
    )
      bonus = pitches_bonus(frame, STRIKE_BONUS_PITCHES)
      set_score_to_frame(frame, bonus, index)
    end
  end

  def run_default_rule(frame, index)
    set_score_to_frame(frame, DEFAULT_BONUS_PITCH, index) if frame.open? && frame.is_second_pitch?
  end

  def set_score_to_frame(frame, bonus, index)
    previous_frame = get_previous_frame(index)
    frame_score = sum_score_to_frame(previous_frame, frame, bonus)
    frame.update_to_ends_status(frame_score)
  end

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

  def has_next_pitches?(frame, qty)
    get_first_pitches(frame, qty).count == qty
  end

  def is_last_frame_with_bonus(frame, pitches_qty)
    frames.count == 10 && frame.pitches.count == pitches_qty
  end

  def get_previous_frame(index)
    return nil if index == 0
    frames[index - 1]
  end

  def update_status
    if frames.select(&:ends?).count.to_i == 10
      self.status = Game.statuses['ends']
    end
  end
end
