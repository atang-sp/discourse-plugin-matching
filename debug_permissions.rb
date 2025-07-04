#!/usr/bin/env ruby

# 调试实践配对权限问题的脚本
puts "=== 调试实践配对权限问题 ==="

# 检查设置
puts "\n1. 检查设置:"
puts "practice_matching_enabled: #{SiteSetting.practice_matching_enabled}"
puts "practice_matching_min_trust_level: #{SiteSetting.practice_matching_min_trust_level}"

# 检查用户
puts "\n2. 检查用户:"
diana_user = User.find_by(username: 'diana_ux')
if diana_user
  puts "diana_ux 用户信息:"
  puts "  ID: #{diana_user.id}"
  puts "  Trust Level: #{diana_user.trust_level}"
  puts "  Admin: #{diana_user.admin?}"
  puts "  Moderator: #{diana_user.moderator?}"
  puts "  Staff: #{diana_user.staff?}"
  puts "  Has required trust level: #{diana_user.has_trust_level?(SiteSetting.practice_matching_min_trust_level)}"
else
  puts "未找到 diana_ux 用户"
end

# 检查管理员用户
admin_user = User.where(admin: true).first
if admin_user
  puts "\n管理员用户信息:"
  puts "  Username: #{admin_user.username}"
  puts "  Trust Level: #{admin_user.trust_level}"
  puts "  Admin: #{admin_user.admin?}"
  puts "  Staff: #{admin_user.staff?}"
  puts "  Has required trust level: #{admin_user.has_trust_level?(SiteSetting.practice_matching_min_trust_level)}"
end

# 检查数据库表
puts "\n3. 检查数据库表:"
if ActiveRecord::Base.connection.table_exists?('practice_interests')
  puts "practice_interests 表存在"
  count = PracticeMatching::PracticeInterest.count
  puts "当前记录数: #{count}"
  
  if count > 0
    puts "最近的记录:"
    PracticeMatching::PracticeInterest.limit(5).each do |record|
      user = User.find_by(id: record.user_id)
      target = User.find_by(id: record.target_user_id)
      puts "  User: #{user&.username} -> Target: #{target&.username}"
    end
  end
else
  puts "practice_interests 表不存在"
end

puts "\n=== 调试完成 ===" 