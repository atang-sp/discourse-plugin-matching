# 在 Discourse Docker 环境中添加测试用户

## 快速开始

### 方法一：使用提供的脚本（推荐）

1. **确保 Discourse Docker 环境正在运行**
   ```bash
   # 在 Discourse 根目录中
   d/boot_dev
   
   # 在另一个终端中启动 Rails 服务器
   d/rails s
   ```

2. **运行用户添加脚本**
   ```bash
   # 将脚本复制到 Discourse 目录
   cp add_test_users.sh /path/to/discourse/
   cd /path/to/discourse
   
   # 执行脚本
   ./add_test_users.sh
   ```

### 方法二：手动执行

1. **进入 Discourse 容器**
   ```bash
   d/shell
   ```

2. **在容器内执行 Rails 控制台**
   ```bash
   rails console
   ```

3. **复制并粘贴以下代码**
   ```ruby
   # 测试用户数据
   test_users = [
     {username: "alice_dev", email: "alice@example.com", name: "Alice Developer"},
     {username: "bob_tester", email: "bob@example.com", name: "Bob Tester"},
     {username: "charlie_qa", email: "charlie@example.com", name: "Charlie QA"},
     {username: "diana_ux", email: "diana@example.com", name: "Diana UX"},
     {username: "edward_ba", email: "edward@example.com", name: "Edward BA"}
   ]
   
   test_users.each do |data|
     unless User.find_by(username: data[:username])
       user = User.new(
         username: data[:username],
         email: data[:email],
         name: data[:name],
         password: "password123",
         password_confirmation: "password123",
         active: true,
         approved: true,
         trust_level: 1
       )
       user.save!
       puts "创建用户: #{data[:username]}"
     else
       puts "用户已存在: #{data[:username]}"
     end
   end
   ```

## 创建的用户信息

| 用户名 | 姓名 | 邮箱 | 密码 |
|--------|------|------|------|
| alice_dev | Alice Developer | alice@example.com | password123 |
| bob_tester | Bob Tester | bob@example.com | password123 |
| charlie_qa | Charlie QA | charlie@example.com | password123 |
| diana_ux | Diana UX | diana@example.com | password123 |
| edward_ba | Edward BA | edward@example.com | password123 |

## 访问地址

- **开发环境**: http://localhost:4200
- **生产环境**: 根据你的配置

## 故障排除

### 1. 容器未运行
```bash
# 检查容器状态
docker ps | grep discourse

# 启动容器
d/boot_dev
```

### 2. 权限错误
```bash
# 确保在 Discourse 根目录
pwd
# 应该显示 /path/to/discourse

# 检查脚本权限
ls -la add_test_users.sh
```

### 3. Rails 服务器未启动
```bash
# 在另一个终端中启动
d/rails s
```

### 4. 用户创建失败
```bash
# 检查数据库连接
d/rails db:migrate:status

# 查看错误日志
d/rails runner "puts User.count"
```

## 验证用户创建

1. **在浏览器中访问**: http://localhost:4200
2. **使用任意测试用户登录**
3. **检查用户列表**: 在管理员面板中查看用户

## 清理测试用户（可选）

如果需要删除测试用户：

```ruby
# 在 Rails 控制台中
test_usernames = ["alice_dev", "bob_tester", "charlie_qa", "diana_ux", "edward_ba"]
test_usernames.each do |username|
  user = User.find_by(username: username)
  user&.destroy
  puts "删除用户: #{username}"
end
```

## 相关文档

- [Discourse Docker 开发环境安装](https://meta.discourse.org/t/install-discourse-for-development-using-docker/102009)
- [Discourse 插件开发指南](https://docs.discourse.org/t/developing-plugins-for-discourse/106485) 