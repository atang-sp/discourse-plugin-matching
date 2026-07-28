# frozen_string_literal: true

RSpec.describe "Practice matching security" do
  fab!(:user)
  fab!(:target_user, :user)

  before do
    SiteSetting.practice_matching_enabled = true
    SiteSetting.practice_matching_min_trust_level = 0
    sign_in(user)
  end

  it "rejects state changes that do not include a CSRF token" do
    ActionController::Base.allow_forgery_protection = true

    post "/api/practice-matching/add.json",
         params: {
           username: target_user.username
         }

    expect(response.status).to eq(403)
    expect(
      PracticeMatching::PracticeInterest.exists?(
        user: user,
        target_user: target_user
      )
    ).to eq(false)
  ensure
    ActionController::Base.allow_forgery_protection = false
  end

  it "does not expose another member's unilateral interest" do
    PracticeMatching::PracticeInterest.create!(
      user: target_user,
      target_user: user
    )

    get "/api/practice-matching.json"

    expect(response.status).to eq(200)
    expect(response.parsed_body).not_to have_key("practice_targets")
    expect(response.body).not_to include(target_user.username)
  end

  it "does not inject private practice data into user serializers" do
    PracticeMatching::PracticeInterest.create!(
      user: target_user,
      target_user: user
    )

    serialized =
      UserSerializer.new(
        target_user,
        scope: Guardian.new(user),
        root: false
      ).as_json

    expect(serialized.keys.map(&:to_s)).not_to include(
      "practice_interests",
      "practice_matches",
      "can_manage_practice_interests"
    )
  end

  it "removes the production test endpoint" do
    get "/api/practice-matching/test.json"

    expect(response.status).to eq(404)
  end

  it "announces deprecation and the replacement flow" do
    get "/api/practice-matching.json"

    expect(response.status).to eq(200)
    expect(response.parsed_body).to include(
      "deprecated" => true,
      "replacement_url" => "/where-is-my-friends/interests"
    )
  end
end
