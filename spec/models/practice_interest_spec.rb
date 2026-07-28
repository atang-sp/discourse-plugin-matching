# frozen_string_literal: true

RSpec.describe PracticeMatching::PracticeInterest do
  fab!(:user)
  fab!(:target_user, :user)

  before { SiteSetting.practice_matching_enabled = true }

  it "uses the shared custom notification type with a navigable action for a mutual match" do
    described_class.create!(user: user, target_user: target_user)

    expect do
      described_class.create!(user: target_user, target_user: user)
    end.to change { Notification.count }.by(2)

    notifications = Notification.last(2)

    expect(notifications.map(&:notification_type)).to all(
      eq(Notification.types[:custom])
    )
    expect(
      notifications.map do |notification|
        JSON.parse(notification.data)["action_url"]
      end
    ).to all(eq("/practice-matching"))
  end
end
