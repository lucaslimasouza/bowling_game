class FrameSerializer < ActiveModel::Serializer
  attributes :id, :status, :total_pins, :score
end
