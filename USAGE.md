# Discourse 测试用户添加 - 使用说明

## 问题修复

之前的错误已修复：
- ✅ 移除了不存在的 `password_confirmation` 属性
- ✅ 修复了 Rails runner 命令格式问题

## 快速使用

### 方法一：使用简单脚本（推荐）

```bash
# 1. 确保在 Discourse 根目录
cd /path/to/discourse

# 2. 复制脚本到 Discourse 目录
cp /path/to/discourse-plugin-matching/simple_add_users.rb .

# 3. 执行脚本
d/rails runner simple_add_users.rb
```

### 方法二：使用快速脚本

```bash
# 1. 复制脚本到 Discourse 目录
cp /path/to/discourse-plugin-matching/quick_add_users.sh .

# 2. 执行脚本
./quick_add_users.sh
```

### 方法三：手动执行

```bash
# 1. 进入容器
d/shell

# 2. 启动 Rails 控制台
rails console

# 3. 复制粘贴以下代码
```

```ruby
test_users = [
  {username: 'alice_dev', email: 'alice@example.com', name: 'Alice Developer'},
  {username: 'bob_tester', email: 'bob@example.com', name: 'Bob Tester'},
  {username: 'charlie_qa', email: 'charlie@example.com', name: 'Charlie QA'},
  {username: 'diana_ux', email: 'diana@example.com', name: 'Diana UX'},
  {username: 'edward_ba', email: 'edward@example.com', name: 'Edward BA'}
]

test_users.each do |data|
  unless User.find_by(username: data[:username])
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
      puts "✅ 创建用户: #{data[:username]}"
    else
      puts "❌ 创建失败: #{data[:username]}"
    end
  else
    puts "⏭️ 用户已存在: #{data[:username]}"
  end
end
```

## 测试用户信息

| 用户名 | 姓名 | 邮箱 | 密码 |
|--------|------|------|------|
| alice_dev | Alice Developer | alice@example.com | password123 |
| bob_tester | Bob Tester | bob@example.com | password123 |
| charlie_qa | Charlie QA | charlie@example.com | password123 |
| diana_ux | Diana UX | diana@example.com | password123 |
| edward_ba | Edward BA | edward@example.com | password123 |

## 访问地址

- **开发环境**: http://localhost:4200
- **登录**: 使用任意测试用户名 + `password123`

## 故障排除

如果遇到问题：

1. **确保 Discourse 容器正在运行**
   ```bash
   docker ps | grep discourse
   ```

2. **确保在正确的目录**
   ```bash
   pwd  # 应该显示 Discourse 根目录
   ls d/boot_dev  # 应该存在此文件
   ```

3. **检查 Rails 服务器**
   ```bash
   # 在另一个终端中启动
   d/rails s
   ``` 