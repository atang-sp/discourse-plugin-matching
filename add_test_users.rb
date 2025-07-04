#!/usr/bin/env ruby
# frozen_string_literal: true

# 添加测试用户脚本
# 使用方法: rails runner add_test_users.rb

puts "开始添加测试用户..."

# 测试用户数据
test_users = [
  {
    username: "alice_dev",
    email: "alice@example.com",
    name: "Alice Developer",
    password: "password123"
  },
  {
    username: "bob_tester", 
    email: "bob@example.com",
    name: "Bob Tester",
    password: "password123"
  },
  {
    username: "charlie_qa",
    email: "charlie@example.com", 
    name: "Charlie QA",
    password: "password123"
  },
  {
    username: "diana_ux",
    email: "diana@example.com",
    name: "Diana UX",
    password: "password123"
  },
  {
    username: "edward_ba",
    email: "edward@example.com",
    name: "Edward BA",
    password: "password123"
  }
]

created_users = []

test_users.each do |user_data|
  begin
    # 检查用户是否已存在
    existing_user = User.find_by(username: user_data[:username])
    
    if existing_user
      puts "用户 #{user_data[:username]} 已存在，跳过创建"
      created_users << existing_user
      next
    end

    # 创建新用户
    user = User.new(
      username: user_data[:username],
      email: user_data[:email],
      name: user_data[:name],
      password: user_data[:password],
      active: true,
      approved: true,
      trust_level: 1
    )

    if user.save
      puts "✓ 成功创建用户: #{user_data[:username]} (#{user_data[:name]})"
      created_users << user
    else
      puts "✗ 创建用户失败: #{user_data[:username]} - #{user.errors.full_messages.join(', ')}"
    end

  rescue => e
    puts "✗ 创建用户时出错: #{user_data[:username]} - #{e.message}"
  end
end

puts "\n=== 创建结果 ==="
puts "总共尝试创建: #{test_users.length} 个用户"
puts "成功创建: #{created_users.length} 个用户"

if created_users.any?
  puts "\n创建的用户列表:"
  created_users.each do |user|
    puts "- #{user.username} (#{user.name}) - #{user.email}"
  end
  
  puts "\n登录信息:"
  puts "用户名: 见上方列表"
  puts "密码: password123"
  puts "访问地址: http://localhost:4200 (开发环境)"
end

puts "\n脚本执行完成！" 