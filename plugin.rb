# frozen_string_literal: true

# name: discourse-plugin-matching
# about: 允许用户添加想约实践的人，当双方都想和对方约实践时通知两人
# version: 1.0.2
# authors: 阿汤
# url: https://github.com/atang-sp/discourse-plugin-matching
# type: plugin

enabled_site_setting :practice_matching_enabled

register_asset "stylesheets/practice-matching.scss"

register_svg_icon "practice-matching"
register_svg_icon "practice-match-found"

module ::PracticeMatching
  PLUGIN_NAME = "discourse-plugin-matching"
end

require_relative "lib/practice_matching/engine"

after_initialize do
  # 添加用户扩展
  reloadable_patch { |plugin| User.prepend(PracticeMatching::UserExtension) }

  # 添加路由
  Discourse::Application.routes.append do
    # 前端路由 - 渲染 Discourse 应用，交给 Ember 客户端路由
    get "/practice-matching" => "list#latest",
        :constraints => ->(request) { request.format.html? }

    # API路由 - 使用 /api 前缀
    get "/api/practice-matching" => "practice_matching#index"
    post "/api/practice-matching/add" => "practice_matching#add_interest"
    delete "/api/practice-matching/remove" =>
             "practice_matching#remove_interest"
  end
end
