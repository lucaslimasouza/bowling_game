class Game < ApplicationRecord
  validates :user_name, presence: true
end
