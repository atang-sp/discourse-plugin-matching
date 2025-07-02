# frozen_string_literal: true

class CreatePracticeInterests < ActiveRecord::Migration[7.0]
  def change
    create_table :practice_interests do |t|
      t.integer :user_id, null: false
      t.integer :target_user_id, null: false
      t.timestamps
    end

    add_index :practice_interests, [:user_id, :target_user_id], unique: true
    add_index :practice_interests, :target_user_id
  end
end
