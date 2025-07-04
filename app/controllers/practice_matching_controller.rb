# frozen_string_literal: true

class PracticeMatchingController < ApplicationController
  before_action :ensure_logged_in
  before_action :ensure_practice_matching_enabled
  skip_before_action :check_xhr, only: [:index, :test]
  skip_before_action :verify_authenticity_token, only: [:add_interest, :remove_interest]

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
    Rails.logger.info "=== Adding Practice Interest ==="
    Rails.logger.info "Request method: #{request.method}"
    Rails.logger.info "Request params: #{params.inspect}"
    Rails.logger.info "Request headers: #{request.headers.to_h.select { |k,v| k.start_with?('HTTP_') }}"
    Rails.logger.info "Current user: #{current_user&.username} (ID: #{current_user&.id})"
    Rails.logger.info "Current user trust level: #{current_user&.trust_level}"
    Rails.logger.info "Current user admin: #{current_user&.admin?}"
    Rails.logger.info "Current user staff: #{current_user&.staff?}"
    Rails.logger.info "Practice matching enabled: #{SiteSetting.practice_matching_enabled}"
    Rails.logger.info "Min trust level required: #{SiteSetting.practice_matching_min_trust_level}"
    
    target_username = params[:username]
    Rails.logger.info "Target username: #{target_username}"
    
    unless target_username
      Rails.logger.error "No username provided in params"
      return render json: { error: "用户名不能为空" }, status: 400
    end
    
    target_user = User.find_by(username: target_username)
    
    unless target_user
      Rails.logger.warn "Target user not found: #{target_username}"
      return render json: { error: "用户不存在" }, status: 404
    end
    
    Rails.logger.info "Target user found: #{target_user.username} (ID: #{target_user.id})"

    begin
      Rails.logger.info "Creating practice interest..."
      result = current_user.add_practice_interest(target_user)
      Rails.logger.info "Add practice interest result: #{result}"
      
      case result
      when true
        Rails.logger.info "Practice interest created successfully"
        render json: { success: true, message: "已添加 #{target_username} 到实践兴趣列表" }
      when :self_user
        Rails.logger.warn "User trying to add self"
        render json: { error: "不能添加自己到实践兴趣列表" }, status: 400
      when :already_exists
        Rails.logger.warn "Practice interest already exists"
        render json: { error: "已经添加过 #{target_username} 到实践兴趣列表了" }, status: 400
      when :creation_failed
        Rails.logger.error "Failed to create practice interest record"
        render json: { error: "添加失败，请重试" }, status: 400
      else
        Rails.logger.error "Unknown result from add_practice_interest: #{result}"
        render json: { error: "添加失败，请重试" }, status: 400
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Record validation error: #{e.record.errors.full_messages}"
      render json: { error: e.record.errors.full_messages.join(", ") }, status: 400
    rescue => e
      Rails.logger.error "Unexpected error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render json: { error: "服务器错误，请重试" }, status: 500
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

  def test
    Rails.logger.info "=== Test endpoint called ==="
    Rails.logger.info "Current user: #{current_user&.username}"
    Rails.logger.info "Request method: #{request.method}"
    Rails.logger.info "Request params: #{params.inspect}"
    
    render json: { 
      success: true, 
      message: "测试端点工作正常",
      user: current_user&.username,
      timestamp: Time.current
    }
  end

  private

  def ensure_practice_matching_enabled
    Rails.logger.info "=== Checking Practice Matching Permissions ==="
    Rails.logger.info "Current user: #{current_user&.username}"
    Rails.logger.info "Practice matching enabled: #{SiteSetting.practice_matching_enabled}"
    Rails.logger.info "Min trust level required: #{SiteSetting.practice_matching_min_trust_level}"
    Rails.logger.info "Current user trust level: #{current_user&.trust_level}"
    Rails.logger.info "Current user has required trust level: #{current_user&.has_trust_level?(SiteSetting.practice_matching_min_trust_level)}"
    Rails.logger.info "Current user is staff: #{current_user&.staff?}"
    
    unless SiteSetting.practice_matching_enabled
      Rails.logger.warn "Practice matching is disabled"
      render json: { error: "实践配对功能已禁用" }, status: 403
      return
    end
    
    min_trust_level = SiteSetting.practice_matching_min_trust_level
    unless current_user.has_trust_level?(min_trust_level) || current_user.staff?
      Rails.logger.warn "User #{current_user.username} does not have sufficient trust level (has: #{current_user.trust_level}, required: #{min_trust_level})"
      render json: { error: "你的信任等级不足以使用此功能" }, status: 403
      return
    end
    
    Rails.logger.info "Permission check passed for user #{current_user.username}"
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