class PracticeInterestsController < ApplicationController
  before_action :ensure_logged_in

  def index
    # 我的实践兴趣
    interests = PracticeMatching::PracticeInterest.where(user_id: current_user.id).includes(:target_user)
    
    # 想和我约实践的人
    targets = PracticeMatching::PracticeInterest.where(target_user_id: current_user.id).includes(:user)
    
    # 计算双向匹配
    interest_user_ids = interests.pluck(:target_user_id)
    target_user_ids = targets.pluck(:user_id)
    match_user_ids = interest_user_ids & target_user_ids
    
    matches = User.where(id: match_user_ids)

    # 添加调试日志
    Rails.logger.info "=== Practice Interests Debug ==="
    Rails.logger.info "Current user: #{current_user.username} (ID: #{current_user.id})"
    Rails.logger.info "Interests count: #{interests.count}"
    Rails.logger.info "Interests SQL: #{interests.to_sql}"
    Rails.logger.info "Targets count: #{targets.count}"
    Rails.logger.info "Targets SQL: #{targets.to_sql}"
    Rails.logger.info "Interest user IDs: #{interest_user_ids}"
    Rails.logger.info "Target user IDs: #{target_user_ids}"
    Rails.logger.info "Match user IDs: #{match_user_ids}"
    Rails.logger.info "Matches count: #{matches.count}"
    
    # 检查数据库中的实际数据
    all_interests = PracticeMatching::PracticeInterest.all
    Rails.logger.info "Total practice interests in DB: #{all_interests.count}"
    all_interests.each do |interest|
      Rails.logger.info "  Interest: User #{interest.user_id} -> Target #{interest.target_user_id}"
    end

    render json: {
      practice_interests: interests.map { |i| user_json(i.target_user) },
      practice_targets: targets.map { |t| user_json(t.user) },
      practice_matches: matches.map { |u| user_json(u) }
    }
  end

  def create
    target_username = params[:username]
    target_user = User.find_by(username: target_username)
    
    # 添加调试日志
    Rails.logger.info "=== Create Practice Interest Debug ==="
    Rails.logger.info "Current user: #{current_user.username} (ID: #{current_user.id})"
    Rails.logger.info "Target username: #{target_username}"
    Rails.logger.info "Target user found: #{target_user.present?}"
    Rails.logger.info "Target user ID: #{target_user&.id}"
    
    unless target_user
      return render json: { error: I18n.t("practice_matching.errors.user_not_found", username: target_username) }, status: 404
    end
    
    practice_interest = PracticeMatching::PracticeInterest.new(
      user_id: current_user.id,
      target_user_id: target_user.id
    )
    
    Rails.logger.info "Practice interest object: #{practice_interest.inspect}"
    Rails.logger.info "Practice interest valid: #{practice_interest.valid?}"
    Rails.logger.info "Practice interest errors: #{practice_interest.errors.full_messages}" unless practice_interest.valid?
    
    if practice_interest.save
      Rails.logger.info "Practice interest saved successfully with ID: #{practice_interest.id}"
      
      # 验证保存后的数据
      saved_interest = PracticeMatching::PracticeInterest.find(practice_interest.id)
      Rails.logger.info "Saved interest verification: #{saved_interest.inspect}"
      
      render json: { success: true, user: user_json(target_user) }
    else
      Rails.logger.error "Failed to save practice interest: #{practice_interest.errors.full_messages}"
      render json: { error: practice_interest.errors.full_messages.join(", ") }, status: 422
    end
  end

  def destroy
    target_username = params[:username]
    target_user = User.find_by(username: target_username)
    
    unless target_user
      return render json: { error: I18n.t("practice_matching.errors.user_not_found", username: target_username) }, status: 404
    end
    
    practice_interest = PracticeMatching::PracticeInterest.find_by(
      user_id: current_user.id,
      target_user_id: target_user.id
    )
    
    if practice_interest&.destroy
      render json: { success: true }
    else
      render json: { error: I18n.t("practice_matching.errors.record_not_found") }, status: 404
    end
  end

  private

  def user_json(user)
    {
      id: user.id,
      username: user.username,
      name: user.name || user.username,
      avatar_template: user.avatar_template
    }
  end
end 