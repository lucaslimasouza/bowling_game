class Game < ApplicationRecord
  validates :user_name, presence: true
  validates :score, numericality: { less_than_or_equal_to: 300 }
end
