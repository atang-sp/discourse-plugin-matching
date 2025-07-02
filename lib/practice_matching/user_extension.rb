# frozen_string_literal: true

module PracticeMatching::UserExtension
  def self.prepended(base)
    base.has_many :practice_interests, class_name: "PracticeMatching::PracticeInterest", dependent: :delete_all
    base.has_many :practice_targets, class_name: "PracticeMatching::PracticeInterest", foreign_key: :target_user_id, dependent: :delete_all
  end

  def practice_matches
    PracticeMatching::PracticeInterest.matches_for_user(self)
  end

  def add_practice_interest(target_user)
    return false if target_user == self
    
    practice_interests.create!(target_user: target_user)
  rescue ActiveRecord::RecordInvalid => e
    false
  end

  def remove_practice_interest(target_user)
    practice_interests.where(target_user: target_user).destroy_all
  end

  def has_practice_interest_in?(target_user)
    practice_interests.exists?(target_user: target_user)
  end

  def practice_interests_list
    practice_interests.includes(:target_user).map(&:target_user)
  end

  def practice_targets_list
    practice_targets.includes(:user).map(&:user)
  end
end 