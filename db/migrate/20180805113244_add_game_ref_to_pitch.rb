class AddGameRefToPitch < ActiveRecord::Migration[5.2]
  def change
    add_reference :pitches, :game, foreign_key: true
  end
end
