# frozen_string_literal: true

module PracticeMatching::UserExtension
  def self.prepended(base)
    base.has_many :practice_interests,
                  class_name: "PracticeMatching::PracticeInterest",
                  dependent: :delete_all
    base.has_many :practice_targets,
                  class_name: "PracticeMatching::PracticeInterest",
                  foreign_key: :target_user_id,
                  dependent: :delete_all
  end

  def practice_matches
    PracticeMatching::PracticeInterest.matches_for_user(self)
  end

  def add_practice_interest(target_user)
    # Return specific error codes for different failure reasons
    return :self_user if target_user == self
    if practice_interests.exists?(target_user: target_user)
      return :already_exists
    end

    # Create the practice interest
    begin
      practice_interests.create!(target_user: target_user)
      true
    rescue ActiveRecord::RecordInvalid
      :creation_failed
    rescue StandardError
      :creation_failed
    end
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
