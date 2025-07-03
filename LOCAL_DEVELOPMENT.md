# 本地开发指南

## 快速开始

### 1. 安装依赖

确保你的系统已安装以下依赖：

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install ruby ruby-dev postgresql postgresql-contrib redis-server nodejs yarn

# macOS (使用 Homebrew)
brew install ruby postgresql redis node yarn

# Arch Linux
sudo pacman -S ruby postgresql redis nodejs yarn
```

### 2. 设置 Discourse 开发环境

```bash
# 克隆 Discourse
git clone https://github.com/discourse/discourse.git
cd discourse

# 安装 Ruby 依赖
bundle install

# 安装 JavaScript 依赖
yarn install

# 设置数据库
createdb discourse_development
rails db:migrate RAILS_ENV=development
```

### 3. 安装插件

```bash
# 复制插件到 plugins 目录
cp -r /path/to/discourse-practice-matching plugins/discourse-plugin-matching

# 或者使用安装脚本
./install.sh
```

### 4. 启动开发服务器

```bash
# 使用提供的脚本
./dev-server.sh

# 或者直接启动
rails server -p 3000 -e development
```

## 开发工作流

### 1. 修改代码

在 `plugins/discourse-plugin-matching/` 目录中修改代码：

- `assets/javascripts/` - 前端 JavaScript 代码
- `assets/stylesheets/` - CSS 样式
- `app/controllers/` - 后端控制器
- `lib/` - Ruby 模型和扩展

### 2. 实时预览

开发服务器支持热重载，大部分更改会自动生效：

- JavaScript 文件更改会自动重新加载
- CSS 文件更改会自动重新加载
- Ruby 文件更改需要重启服务器

### 3. 调试

#### 前端调试

1. 打开浏览器开发者工具
2. 查看控制台错误
3. 使用 `console.log()` 调试 JavaScript
4. 检查网络请求

#### 后端调试

1. 查看服务器日志：`tail -f log/development.log`
2. 使用 Rails 控制台：`rails console`
3. 添加 `puts` 或 `Rails.logger.debug` 调试输出

### 4. 测试

```bash
# 运行所有测试
rails test

# 运行特定测试
rails test test/controllers/practice_matching_controller_test.rb

# 运行前端测试
yarn test
```

## 常用命令

### 开发服务器

```bash
# 启动开发服务器
./dev-server.sh

# 启动调试服务器
./debug-plugin.sh

# 停止服务器
Ctrl+C
```

### 数据库操作

```bash
# 运行迁移
rails db:migrate RAILS_ENV=development

# 重置数据库
rails db:reset RAILS_ENV=development

# 进入数据库控制台
rails dbconsole
```

### 代码生成

```bash
# 生成控制器
rails generate controller PracticeMatching

# 生成模型
rails generate model PracticeInterest

# 生成迁移
rails generate migration AddFieldToTable
```

### 调试工具

```bash
# 查看路由
rails routes | grep practice-matching

# 进入 Rails 控制台
rails console

# 查看日志
tail -f log/development.log

# 检查插件状态
rails runner "puts Plugin::Instance.find_by_name('discourse-plugin-matching')&.enabled?"
```

## 文件结构

```
discourse/
├── plugins/
│   └── discourse-plugin-matching/
│       ├── assets/
│       │   ├── javascripts/
│       │   │   ├── initializers/
│       │   │   │   └── practice-matching.js
│       │   │   └── discourse/
│       │   │       ├── routes/
│       │   │       │   └── practice-matching.js
│       │   │       ├── controllers/
│       │   │       │   └── practice-matching.js
│       │   │       └── templates/
│       │   │           └── practice-matching.hbs
│       │   └── stylesheets/
│       │       └── common/
│       │           └── practice-matching.scss
│       ├── app/
│       │   └── controllers/
│       │       └── practice_matching_controller.rb
│       ├── lib/
│       │   └── practice_matching/
│       │       ├── engine.rb
│       │       ├── practice_interest.rb
│       │       └── user_extension.rb
│       ├── db/
│       │   └── migrate/
│       │       └── create_practice_interests.rb
│       ├── config/
│       │   └── settings.yml
│       └── plugin.rb
└── ...
```

## 故障排除

### 常见问题

1. **端口被占用**
   ```bash
   # 查找占用端口的进程
   lsof -i :3000
   
   # 杀死进程
   kill -9 <PID>
   ```

2. **数据库连接错误**
   ```bash
   # 检查 PostgreSQL 状态
   sudo systemctl status postgresql
   
   # 启动 PostgreSQL
   sudo systemctl start postgresql
   ```

3. **依赖安装失败**
   ```bash
   # 清理并重新安装
   bundle clean --force
   bundle install
   
   yarn cache clean
   yarn install
   ```

4. **插件不生效**
   ```bash
   # 重启服务器
   Ctrl+C
   rails server -p 3000 -e development
   
   # 清除缓存
   rails tmp:clear
   ```

### 调试技巧

1. **使用浏览器开发者工具**
   - 查看控制台错误
   - 检查网络请求
   - 调试 JavaScript

2. **使用 Rails 日志**
   ```bash
   tail -f log/development.log
   ```

3. **使用 Rails 控制台**
   ```bash
   rails console
   # 测试模型
   PracticeMatching::PracticeInterest.all
   ```

4. **检查路由**
   ```bash
   rails routes | grep practice-matching
   ```

## 部署到生产环境

完成本地开发后，将更改部署到生产环境：

```bash
# 提交代码
git add .
git commit -m "Your changes"
git push

# 在生产服务器上
./launcher rebuild app
./launcher restart app
```

## 更多资源

- [Discourse 开发文档](https://docs.discourse.org/)
- [Discourse 插件开发指南](https://docs.discourse.org/t/developing-plugins-for-discourse/106485)
- [Rails 开发指南](https://guides.rubyonrails.org/)
- [Ember.js 文档](https://guides.emberjs.com/) 