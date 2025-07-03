#!/bin/bash

# 快速启动 Discourse Practice Matching Plugin 本地开发环境

echo "=== 快速启动本地开发环境 ==="
echo ""

# 检查是否在Discourse目录中
if [ ! -f "config/database.yml" ]; then
    echo "❌ 错误: 请在Discourse安装目录中运行此脚本"
    echo ""
    echo "请先："
    echo "1. 克隆 Discourse: git clone https://github.com/discourse/discourse.git"
    echo "2. 进入目录: cd discourse"
    echo "3. 安装依赖: bundle install && yarn install"
    echo "4. 设置数据库: createdb discourse_development"
    echo "5. 运行迁移: rails db:migrate RAILS_ENV=development"
    echo "6. 安装插件: cp -r /path/to/discourse-practice-matching plugins/discourse-plugin-matching"
    echo "7. 再次运行此脚本"
    exit 1
fi

echo "✅ 确认在Discourse目录中"
echo ""

# 检查插件是否安装
if [ ! -d "plugins/discourse-plugin-matching" ]; then
    echo "❌ 错误: 插件未安装"
    echo ""
    echo "请先安装插件："
    echo "cp -r /path/to/discourse-practice-matching plugins/discourse-plugin-matching"
    exit 1
fi

echo "✅ 插件已安装"
echo ""

# 检查依赖
echo "检查依赖..."
if ! command -v bundle &> /dev/null; then
    echo "❌ 错误: bundle 未安装，请先安装 Ruby 和 Bundler"
    exit 1
fi

if ! command -v yarn &> /dev/null; then
    echo "❌ 错误: yarn 未安装，请先安装 Node.js 和 Yarn"
    exit 1
fi

if ! command -v psql &> /dev/null; then
    echo "❌ 错误: PostgreSQL 未安装，请先安装 PostgreSQL"
    exit 1
fi

echo "✅ 依赖检查通过"
echo ""

# 检查数据库
echo "检查数据库..."
if ! psql -lqt | cut -d \| -f 1 | grep -qw discourse_development; then
    echo "⚠️  数据库不存在，正在创建..."
    createdb discourse_development
    echo "✅ 数据库创建完成"
else
    echo "✅ 数据库已存在"
fi
echo ""

# 运行迁移
echo "运行数据库迁移..."
rails db:migrate RAILS_ENV=development
echo "✅ 迁移完成"
echo ""

# 启动开发服务器
echo "启动开发服务器..."
echo ""
echo "=== 开发环境信息 ==="
echo "服务器地址: http://localhost:3000"
echo "插件页面: http://localhost:3000/practice-matching"
echo "管理面板: http://localhost:3000/admin"
echo ""
echo "=== 调试信息 ==="
echo "查看日志: tail -f log/development.log"
echo "Rails控制台: rails console"
echo "检查路由: rails routes | grep practice-matching"
echo ""
echo "按 Ctrl+C 停止服务器"
echo ""

# 启动服务器
rails server -p 3000 -e development 