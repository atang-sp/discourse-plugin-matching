# frozen_string_literal: true

module PracticeMatching
  class Engine < ::Rails::Engine
    engine_name PracticeMatching::PLUGIN_NAME
    isolate_namespace PracticeMatching
  end

  class Engine < ::Rails::Engine
    engine_name PracticeMatching::PLUGIN_NAME
    isolate_namespace PracticeMatching
  end
end

# 数据库迁移
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

# 通知类型
class Notification
  def self.types
    @types ||= Enum.new(
      practice_match_found: 900
    )
  end
end 