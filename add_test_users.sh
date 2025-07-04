#!/bin/bash

# 添加测试用户脚本
# 适用于 Discourse Docker 开发环境

echo "=== Discourse 测试用户添加脚本 ==="
echo ""

# 检查是否在 Discourse 目录中
if [ ! -f "d/boot_dev" ]; then
    echo "错误: 请在 Discourse 根目录中运行此脚本"
    echo "当前目录: $(pwd)"
    echo ""
    echo "请先切换到 Discourse 目录:"
    echo "cd /path/to/discourse"
    exit 1
fi

# 检查 Docker 容器是否运行
if ! docker ps | grep -q discourse; then
    echo "错误: Discourse Docker 容器未运行"
    echo ""
    echo "请先启动 Discourse 开发环境:"
    echo "d/boot_dev"
    echo ""
    echo "然后在另一个终端中运行 Rails 服务器:"
    echo "d/rails s"
    exit 1
fi

echo "✓ Discourse Docker 环境已检测到"
echo ""

# 复制用户创建脚本到容器中
echo "正在准备用户创建脚本..."
cat > /tmp/add_test_users.rb << 'EOF'
#!/usr/bin/env ruby
# frozen_string_literal: true

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
      password_confirmation: user_data[:password],
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
EOF

# 在容器中执行脚本
echo "正在在 Discourse 容器中执行用户创建脚本..."
d/rails runner /tmp/add_test_users.rb

echo ""
echo "=== 操作完成 ==="
echo ""
echo "如果用户创建成功，你可以使用以下信息登录:"
echo "- 访问地址: http://localhost:4200"
echo "- 用户名: alice_dev, bob_tester, charlie_qa, diana_ux, edward_ba"
echo "- 密码: password123"
echo ""
echo "提示: 如果遇到权限问题，请确保 Discourse 容器正在运行" 