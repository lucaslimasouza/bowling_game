# frozen_string_literal: true

class CreateFrames < ActiveRecord::Migration[5.2]
  def change
    create_table :frames do |t|
      t.integer :score
      t.integer :total_pins, default: 10
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
