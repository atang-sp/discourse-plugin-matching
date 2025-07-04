#!/usr/bin/env ruby
# frozen_string_literal: true

puts "开始创建 Discourse 测试用户..."

# 测试用户数据
test_users = [
  {username: 'alice_dev', email: 'alice@example.com', name: 'Alice Developer'},
  {username: 'bob_tester', email: 'bob@example.com', name: 'Bob Tester'},
  {username: 'charlie_qa', email: 'charlie@example.com', name: 'Charlie QA'},
  {username: 'diana_ux', email: 'diana@example.com', name: 'Diana UX'},
  {username: 'edward_ba', email: 'edward@example.com', name: 'Edward BA'}
]

created_count = 0

test_users.each do |data|
  # 检查用户是否已存在
  existing_user = User.find_by(username: data[:username])
  
  if existing_user
    puts "⏭️  用户已存在: #{data[:username]}"
    next
  end

  # 创建新用户
  user = User.new(
    username: data[:username],
    email: data[:email],
    name: data[:name],
    password: 'password123',
    active: true,
    approved: true,
    trust_level: 1
  )

  if user.save
    puts "✅ 成功创建用户: #{data[:username]} (#{data[:name]})"
    created_count += 1
  else
    puts "❌ 创建失败: #{data[:username]} - #{user.errors.full_messages.join(', ')}"
  end
end

puts "\n📊 创建结果:"
puts "总共尝试创建: #{test_users.length} 个用户"
puts "成功创建: #{created_count} 个新用户"

puts "\n🔑 登录信息:"
puts "用户名: alice_dev, bob_tester, charlie_qa, diana_ux, edward_ba"
puts "密码: password123"
puts "访问地址: http://localhost:4200"

puts "\n脚本执行完成！" 