# frozen_string_literal: true

require Rails.root.join(
          "plugins/discourse-plugin-matching/db/migrate/20260728000000_migrate_legacy_practice_match_notifications.rb"
        )

RSpec.describe MigrateLegacyPracticeMatchNotifications do
  fab!(:user)

  around { |example| ActiveRecord::Migration.suppress_messages { example.run } }

  def create_notification(type:, message:)
    Notification.create!(
      user: user,
      notification_type: type,
      data: {
        message: message,
        title: "practice_matching.notification.title"
      }.to_json
    )
  end

  it "moves only legacy practice-match rows away from the now-conflicting type 900" do
    legacy_match =
      create_notification(
        type: 900,
        message: "practice_matching.notification.mutual_match"
      )
    circles_notification =
      create_notification(type: 900, message: "circles.activity")
    already_custom =
      create_notification(
        type: Notification.types[:custom],
        message: "practice_matching.notification.mutual_match"
      )

    described_class.new.up

    expect(legacy_match.reload.notification_type).to eq(
      Notification.types[:custom]
    )
    expect(circles_notification.reload.notification_type).to eq(900)
    expect(already_custom.reload.notification_type).to eq(
      Notification.types[:custom]
    )
  end
end
