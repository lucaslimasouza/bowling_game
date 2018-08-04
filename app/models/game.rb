class Game < ApplicationRecord
  validates :user_name, presence: true
  validates :score, numericality: :true
end
