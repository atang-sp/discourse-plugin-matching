# frozen_string_literal: true

class PracticeMatchingController < ApplicationController
  before_action :ensure_logged_in
  before_action :ensure_practice_matching_enabled

  def index
    @user = current_user
    @practice_interests = @user.practice_interests_list
    @practice_targets = @user.practice_targets_list
    @practice_matches = User.where(id: @user.practice_matches)
    
    render json: {
      practice_interests: @practice_interests.map { |u| user_serializer(u) },
      practice_targets: @practice_targets.map { |u| user_serializer(u) },
      practice_matches: @practice_matches.map { |u| user_serializer(u) }
    }
  end

  def add_interest
    target_username = params[:username]
    target_user = User.find_by(username: target_username)
    
    unless target_user
      return render json: { error: "用户不存在" }, status: 404
    end

    if current_user.add_practice_interest(target_user)
      render json: { success: true, message: "已添加 #{target_username} 到实践兴趣列表" }
    else
      render json: { error: "添加失败，可能已经存在或不能添加自己" }, status: 400
    end
  end

  def remove_interest
    target_username = params[:username]
    target_user = User.find_by(username: target_username)
    
    unless target_user
      return render json: { error: "用户不存在" }, status: 404
    end

    current_user.remove_practice_interest(target_user)
    render json: { success: true, message: "已从实践兴趣列表中移除 #{target_username}" }
  end

  private

  def ensure_practice_matching_enabled
    unless SiteSetting.practice_matching_enabled
      render json: { error: "实践配对功能已禁用" }, status: 403
    end
  end

  def user_serializer(user)
    {
      id: user.id,
      username: user.username,
      name: user.name,
      avatar_template: user.avatar_template,
      trust_level: user.trust_level,
      # 添加 avatar 相关字段
      avatar_url: user.avatar_template.present? ? user.avatar_template : nil,
      uploaded_avatar_id: user.uploaded_avatar_id,
      # 添加其他必要字段
      admin: user.admin?,
      moderator: user.moderator?,
      post_count: user.post_count,
      primary_group_name: user.primary_group&.name
    }
  end
end 