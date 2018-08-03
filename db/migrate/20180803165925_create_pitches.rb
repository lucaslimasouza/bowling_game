class CreatePitches < ActiveRecord::Migration[5.2]
  def change
    create_table :pitches do |t|
      t.integer :pins_knocked_down
      t.references :frame, foreign_key: true

      t.timestamps
    end
  end
end
