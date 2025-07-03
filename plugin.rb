# frozen_string_literal: true

# name: discourse-plugin-matching
# about: 允许用户添加想约实践的人，当双方都想和对方约实践时通知两人
# version: 1.0
# authors: 阿汤
# url: https://github.com/atang-sp/discourse-plugin-matching
# type: plugin

enabled_site_setting :practice_matching_enabled

register_asset "stylesheets/common/practice-matching.scss"

register_svg_icon "practice-matching"
register_svg_icon "practice-match-found"

module ::PracticeMatching
  PLUGIN_NAME = "discourse-plugin-matching"
end

require_relative "lib/practice_matching/engine"

after_initialize do
  # 注册新的通知类型
  Notification.types[:practice_match_found] = 900

  # 添加用户扩展
  reloadable_patch { |plugin| User.prepend(PracticeMatching::UserExtension) }

  # 添加序列化器扩展
  add_to_serializer(:user, :practice_interests) do
    PracticeMatching::PracticeInterest.where(user: user).pluck(:target_user_id)
  end

  add_to_serializer(:user, :practice_matches) do
    PracticeMatching::PracticeInterest.matches_for_user(user)
  end

  add_to_serializer(:user, :can_manage_practice_interests) do
    scope.current_user && (scope.current_user.id == user.id || scope.current_user.admin?)
  end

  # 添加路由
  Discourse::Application.routes.append do
    get "/practice-matching" => "practice_matching#index"
    post "/practice-matching/add" => "practice_matching#add_interest"
    delete "/practice-matching/remove" => "practice_matching#remove_interest"
  end
end 