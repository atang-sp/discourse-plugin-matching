#!/bin/bash

# 设置 Discourse Practice Matching Plugin 本地开发环境

echo "=== 设置本地开发环境 ==="
echo ""

# 检查是否在Discourse目录中
if [ ! -f "config/database.yml" ]; then
    echo "❌ 错误: 请在Discourse安装目录中运行此脚本"
    exit 1
fi

echo "✅ 确认在Discourse目录中"
echo ""

# 检查插件是否安装
if [ ! -d "plugins/discourse-plugin-matching" ]; then
    echo "❌ 错误: 插件未安装"
    echo "请先运行 install.sh 脚本安装插件"
    exit 1
fi

echo "✅ 插件已安装"
echo ""

# 步骤1: 创建开发环境配置
echo "步骤 1: 创建开发环境配置..."
if [ ! -f "config/environments/development.rb" ]; then
    echo "⚠️  开发环境配置文件不存在，将创建基本配置"
    cat > config/environments/development.rb << 'EOF'
Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.quiet = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
EOF
    echo "✅ 开发环境配置文件已创建"
else
    echo "✅ 开发环境配置文件已存在"
fi
echo ""

# 步骤2: 设置数据库
echo "步骤 2: 设置数据库..."
if [ ! -f "config/database.yml" ]; then
    echo "⚠️  数据库配置文件不存在，将创建基本配置"
    cat > config/database.yml << 'EOF'
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: discourse_development
  username: postgres
  password: password
  host: localhost

test:
  <<: *default
  database: discourse_test
  username: postgres
  password: password
  host: localhost
EOF
    echo "✅ 数据库配置文件已创建"
else
    echo "✅ 数据库配置文件已存在"
fi
echo ""

# 步骤3: 安装依赖
echo "步骤 3: 安装依赖..."
if command -v bundle &> /dev/null; then
    echo "安装 Ruby 依赖..."
    bundle install
    echo "✅ Ruby 依赖安装完成"
else
    echo "⚠️  bundle 命令未找到，请确保已安装 Ruby 和 Bundler"
fi

if command -v yarn &> /dev/null; then
    echo "安装 JavaScript 依赖..."
    yarn install
    echo "✅ JavaScript 依赖安装完成"
else
    echo "⚠️  yarn 命令未找到，请确保已安装 Node.js 和 Yarn"
fi
echo ""

# 步骤4: 设置数据库
echo "步骤 4: 设置数据库..."
if command -v psql &> /dev/null; then
    echo "创建数据库..."
    createdb discourse_development 2>/dev/null || echo "数据库已存在"
    echo "✅ 数据库设置完成"
else
    echo "⚠️  PostgreSQL 未安装，请先安装 PostgreSQL"
fi
echo ""

# 步骤5: 运行数据库迁移
echo "步骤 5: 运行数据库迁移..."
if command -v rails &> /dev/null; then
    echo "运行迁移..."
    rails db:migrate RAILS_ENV=development
    echo "✅ 数据库迁移完成"
else
    echo "⚠️  rails 命令未找到"
fi
echo ""

# 步骤6: 创建开发脚本
echo "步骤 6: 创建开发脚本..."
cat > dev-server.sh << 'EOF'
#!/bin/bash

# Discourse 本地开发服务器启动脚本

echo "=== 启动 Discourse 本地开发服务器 ==="
echo ""

# 检查环境
if [ ! -f "config/database.yml" ]; then
    echo "❌ 错误: 请在Discourse安装目录中运行此脚本"
    exit 1
fi

echo "✅ 环境检查通过"
echo ""

# 启动开发服务器
echo "启动开发服务器..."
echo "服务器将在 http://localhost:3000 启动"
echo "按 Ctrl+C 停止服务器"
echo ""

# 启动 Rails 开发服务器
rails server -p 3000 -e development
EOF

chmod +x dev-server.sh
echo "✅ 开发服务器脚本已创建"
echo ""

# 步骤7: 创建调试脚本
echo "步骤 7: 创建调试脚本..."
cat > debug-plugin.sh << 'EOF'
#!/bin/bash

# Discourse Practice Matching Plugin 调试脚本

echo "=== 调试插件 ==="
echo ""

# 检查是否在Discourse目录中
if [ ! -f "config/database.yml" ]; then
    echo "❌ 错误: 请在Discourse安装目录中运行此脚本"
    exit 1
fi

echo "✅ 确认在Discourse目录中"
echo ""

# 检查插件
echo "检查插件文件..."
if [ -f "plugins/discourse-plugin-matching/assets/javascripts/initializers/practice-matching.js" ]; then
    echo "✅ 前端初始化文件存在"
else
    echo "❌ 前端初始化文件不存在"
fi

if [ -f "plugins/discourse-plugin-matching/assets/javascripts/discourse/routes/practice-matching.js" ]; then
    echo "✅ 前端路由文件存在"
else
    echo "❌ 前端路由文件不存在"
fi

if [ -f "plugins/discourse-plugin-matching/assets/javascripts/discourse/templates/practice-matching.hbs" ]; then
    echo "✅ 前端模板文件存在"
else
    echo "❌ 前端模板文件不存在"
fi
echo ""

# 检查路由
echo "检查路由..."
if rails routes | grep -q "practice-matching"; then
    echo "✅ 后端路由已配置"
    rails routes | grep "practice-matching"
else
    echo "❌ 后端路由未配置"
fi
echo ""

# 检查数据库
echo "检查数据库..."
if rails runner "puts PracticeMatching::PracticeInterest.table_exists?" 2>/dev/null | grep -q "true"; then
    echo "✅ 数据库表已创建"
else
    echo "❌ 数据库表未创建"
fi
echo ""

# 启动调试服务器
echo "启动调试服务器..."
echo "服务器将在 http://localhost:3000 启动"
echo "插件页面: http://localhost:3000/practice-matching"
echo "按 Ctrl+C 停止服务器"
echo ""

rails server -p 3000 -e development
EOF

chmod +x debug-plugin.sh
echo "✅ 调试脚本已创建"
echo ""

echo "=== 开发环境设置完成 ==="
echo ""
echo "现在你可以使用以下命令进行本地开发："
echo ""
echo "1. 启动开发服务器："
echo "   ./dev-server.sh"
echo ""
echo "2. 调试插件："
echo "   ./debug-plugin.sh"
echo ""
echo "3. 查看日志："
echo "   tail -f log/development.log"
echo ""
echo "4. 进入 Rails 控制台："
echo "   rails console"
echo ""
echo "5. 运行测试："
echo "   rails test"
echo ""
echo "开发服务器将在 http://localhost:3000 启动"
echo "插件页面将在 http://localhost:3000/practice-matching 可用"
echo ""
echo "注意：确保已安装以下依赖："
echo "- Ruby 2.7+ 和 Bundler"
echo "- Node.js 和 Yarn"
echo "- PostgreSQL"
echo "- Redis"
EOF 