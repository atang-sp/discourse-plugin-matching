# frozen_string_literal: true

class MigrateLegacyPracticeMatchNotifications < ActiveRecord::Migration[7.0]
  LEGACY_PRACTICE_MATCH_TYPE = 900
  CUSTOM_NOTIFICATION_TYPE = 14
  PRACTICE_MATCH_MESSAGE = "practice_matching.notification.mutual_match"

  def up
    execute <<~SQL
      UPDATE notifications
      SET notification_type = #{CUSTOM_NOTIFICATION_TYPE}
      WHERE notification_type = #{LEGACY_PRACTICE_MATCH_TYPE}
        AND data::jsonb ->> 'message' = #{connection.quote(PRACTICE_MATCH_MESSAGE)}
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
