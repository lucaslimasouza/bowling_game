class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :user_name
      t.integer :score, default: 0

      t.timestamps
    end
  end
end
