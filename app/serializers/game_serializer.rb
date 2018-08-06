class GameSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :score, :status, :updated_at
  has_many :frames
end
