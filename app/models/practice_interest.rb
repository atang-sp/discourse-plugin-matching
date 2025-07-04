class PracticeInterest < ActiveRecord::Base
  belongs_to :user
  belongs_to :target_user, class_name: 'User'
  
  validates :user_id, presence: true
  validates :target_user_id, presence: true
  validates :user_id, uniqueness: { scope: :target_user_id, message: "已经添加过这个用户了" }
  validate :cannot_add_self
  
  private
  
  def cannot_add_self
    if user_id == target_user_id
      errors.add(:target_user_id, "不能添加自己到实践兴趣列表")
    end
  end
end 