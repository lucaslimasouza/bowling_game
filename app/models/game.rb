class Game < ApplicationRecord
  has_many :frames, dependent: :destroy

  validates :user_name, presence: true
  validates :user_name, length: { maximum: 20 }
  validates :score, numericality: { less_than_or_equal_to: 300 }
  validates :frames, length: { maximum: 10 }

  def current_frame
    frames
      .where(status: Frame.statuses['open'], score: 0)
      .first_or_initialize
  end
end
