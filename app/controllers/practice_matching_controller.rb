# frozen_string_literal: true

class PracticeMatchingController < ApplicationController
  requires_plugin PracticeMatching::PLUGIN_NAME

  before_action :ensure_logged_in
  before_action :ensure_practice_matching_enabled
  before_action :ensure_legacy_read_only, only: %i[add_interest remove_interest]
  skip_before_action :check_xhr, only: [:index]

  def index
    @user = current_user
    @practice_interests = @user.practice_interests_list
    @practice_matches = User.where(id: @user.practice_matches)

    render json: {
             practice_interests:
               @practice_interests.map { |u| user_serializer(u) },
             practice_matches: @practice_matches.map { |u| user_serializer(u) },
             deprecated: true,
             read_only: true,
             replacement_url: "/where-is-my-friends/interests"
           }
  end

  def add_interest
    target_username = params[:username]

    unless target_username
      return(
        render json: {
                 error: I18n.t("practice_matching.errors.username_required")
               },
               status: :bad_request
      )
    end

    target_user = User.find_by(username: target_username)

    unless target_user
      return(
        render json: {
                 error:
                   I18n.t(
                     "practice_matching.errors.user_not_found",
                     username: target_username
                   )
               },
               status: :not_found
      )
    end

    begin
      result = current_user.add_practice_interest(target_user)

      case result
      when true
        render json: {
                 success: true,
                 message:
                   I18n.t(
                     "practice_matching.messages.interest_added",
                     username: target_username
                   )
               }
      when :self_user
        render json: {
                 error: I18n.t("practice_matching.errors.cannot_add_self")
               },
               status: :bad_request
      when :already_exists
        render json: {
                 error: I18n.t("practice_matching.errors.already_exists")
               },
               status: :bad_request
      when :creation_failed
        render json: {
                 error: I18n.t("practice_matching.errors.creation_failed")
               },
               status: :bad_request
      else
        render json: {
                 error: I18n.t("practice_matching.errors.creation_failed")
               },
               status: :bad_request
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: {
               error: e.record.errors.full_messages.join(", ")
             },
             status: :bad_request
    rescue StandardError
      render json: {
               error: I18n.t("practice_matching.errors.server_error")
             },
             status: :internal_server_error
    end
  end

  def remove_interest
    target_username = params[:username]
    target_user = User.find_by(username: target_username)

    unless target_user
      return(
        render json: {
                 error:
                   I18n.t(
                     "practice_matching.errors.user_not_found",
                     username: target_username
                   )
               },
               status: :not_found
      )
    end

    current_user.remove_practice_interest(target_user)
    render json: {
             success: true,
             message:
               I18n.t(
                 "practice_matching.messages.interest_removed",
                 username: target_username
               )
           }
  end

  private

  def ensure_legacy_read_only
    render json: {
             error: I18n.t("practice_matching.errors.read_only")
           },
           status: :gone
  end

  def ensure_practice_matching_enabled
    unless SiteSetting.practice_matching_enabled
      render json: {
               error: I18n.t("practice_matching.errors.feature_disabled")
             },
             status: :forbidden
      return
    end

    min_trust_level = SiteSetting.practice_matching_min_trust_level
    unless current_user.has_trust_level?(min_trust_level) || current_user.staff?
      render json: {
               error:
                 I18n.t("practice_matching.errors.insufficient_trust_level")
             },
             status: :forbidden
      nil
    end
  end

  def user_serializer(user)
    {
      id: user.id,
      username: user.username,
      name: user.name,
      avatar_template: user.avatar_template,
      trust_level: user.trust_level,
      # 添加 avatar 相关字段 - 修复头像URL
      avatar_url: user.avatar_template.presence&.gsub("{size}", "48"),
      uploaded_avatar_id: user.uploaded_avatar_id,
      # 添加其他必要字段
      admin: user.admin?,
      moderator: user.moderator?,
      post_count: user.post_count,
      primary_group_name: user.primary_group&.name
    }
  end
end
