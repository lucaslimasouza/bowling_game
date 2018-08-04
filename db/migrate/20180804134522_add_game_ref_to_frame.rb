class AddGameRefToFrame < ActiveRecord::Migration[5.2]
  def change
    add_reference :frames, :game, foreign_key: true
  end
end
