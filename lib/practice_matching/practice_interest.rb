# frozen_string_literal: true

class PracticeMatching::PracticeInterest < ActiveRecord::Base
  self.table_name = 'practice_interests'

  belongs_to :user
  belongs_to :target_user, class_name: 'User'

  validates :user_id, presence: true
  validates :target_user_id, presence: true
  validates :user_id, uniqueness: { scope: :target_user_id, message: I18n.t("practice_matching.errors.already_exists") }
  validate :cannot_add_self

  after_create :check_for_mutual_match

  def self.matches_for_user(user)
    # 查找双向匹配
    user_interests = where(user: user).pluck(:target_user_id)
    target_interests = where(target_user: user).pluck(:user_id)
    
    # 返回双向匹配的用户ID
    user_interests & target_interests
  end

  def self.mutual_match_exists?(user1_id, user2_id)
    exists?(user_id: user1_id, target_user_id: user2_id) &&
    exists?(user_id: user2_id, target_user_id: user1_id)
  end

  private

  def cannot_add_self
    if user_id == target_user_id
      errors.add(:target_user_id, I18n.t("practice_matching.errors.cannot_add_self"))
    end
  end

  def check_for_mutual_match
    # 检查是否形成双向匹配
    if PracticeMatching::PracticeInterest.mutual_match_exists?(user_id, target_user_id)
      notify_mutual_match
    end
  end

  def notify_mutual_match
    # 通知两个用户找到了匹配
    [user, target_user].each do |matched_user|
      other_user = matched_user == user ? target_user : user
      
      Notification.create!(
        user: matched_user,
        notification_type: Notification.types[:practice_match_found],
        data: {
          username: other_user.username,
          display_username: other_user.username,
          user_id: other_user.id,
          user_avatar_template: other_user.avatar_template,
          topic_id: nil,
          post_number: nil,
          message: I18n.t("practice_matching.messages.mutual_match_notification", username: other_user.username),
          # 添加更多上下文信息
          match_type: "mutual_interest",
          action_url: "/practice-matching",
          action_text: I18n.t("practice_matching.view_match_details")
        }.to_json
      )
    end
  end
end 