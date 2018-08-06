class GameSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :score, :updated_at
  has_many :frames
end
