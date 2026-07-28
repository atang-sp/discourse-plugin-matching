# frozen_string_literal: true

require Rails.root.join(
          "plugins/discourse-plugin-matching/db/migrate/20260728163227_migrate_localized_legacy_practice_match_notifications.rb"
        )

RSpec.describe MigrateLocalizedLegacyPracticeMatchNotifications do
  fab!(:user)

  around { |example| ActiveRecord::Migration.suppress_messages { example.run } }

  def create_notification(type:, data:)
    Notification.create!(
      user: user,
      notification_type: type,
      data: data.to_json
    )
  end

  it "moves every known legacy practice-match payload without claiming unrelated type 900 rows" do
    action_url_match =
      create_notification(
        type: 900,
        data: {
          message: "恭喜，你和 alice 都想和对方约实践！",
          action_url: "/practice-matching"
        }
      )
    early_chinese_match =
      create_notification(
        type: 900,
        data: {
          display_username: "alice",
          username: "alice",
          topic_id: 1,
          post_number: 1,
          message: "你和 alice 都想和对方约实践！"
        }
      )
    early_english_match =
      create_notification(
        type: 900,
        data: {
          display_username: "alice",
          username: "alice",
          topic_id: 1,
          post_number: 1,
          message: "You and alice both want to practice together!"
        }
      )
    unrelated =
      create_notification(
        type: 900,
        data: {
          display_username: "alice",
          username: "alice",
          topic_id: 1,
          post_number: 1,
          message: "A different plugin notification"
        }
      )

    described_class.new.up

    expect(
      [
        action_url_match,
        early_chinese_match,
        early_english_match
      ].map { |notification| notification.reload.notification_type }
    ).to all(eq(Notification.types[:custom]))
    expect(unrelated.reload.notification_type).to eq(900)
  end
end
