# frozen_string_literal: true

class MigrateLocalizedLegacyPracticeMatchNotifications < ActiveRecord::Migration[
  8.0
]
  LEGACY_PRACTICE_MATCH_TYPE = 900
  CUSTOM_NOTIFICATION_TYPE = 14
  PRACTICE_MATCH_MESSAGE = "practice_matching.notification.mutual_match"
  PRACTICE_MATCH_ACTION_URL = "/practice-matching"

  def up
    execute <<~SQL
      UPDATE notifications
      SET notification_type = #{CUSTOM_NOTIFICATION_TYPE}
      WHERE notification_type = #{LEGACY_PRACTICE_MATCH_TYPE}
        AND (
          data::jsonb ->> 'message' =
            #{connection.quote(PRACTICE_MATCH_MESSAGE)}
          OR data::jsonb ->> 'action_url' =
            #{connection.quote(PRACTICE_MATCH_ACTION_URL)}
          OR (
            data::jsonb ? 'display_username'
            AND data::jsonb ? 'username'
            AND data::jsonb ? 'topic_id'
            AND data::jsonb ? 'post_number'
            AND (
              data::jsonb ->> 'message' LIKE '%约实践%'
              OR data::jsonb ->> 'message' ILIKE '%practice together%'
            )
          )
        )
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
