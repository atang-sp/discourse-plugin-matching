#!/bin/bash

echo "Deploying Practice Matching Plugin to Discourse Development Environment"
echo "======================================================================"

# 检查是否在插件目录中
if [ ! -f "plugin.rb" ]; then
    echo "❌ 错误: 请在插件目录中运行此脚本"
    exit 1
fi

# 获取 Discourse 主目录路径
DISCOURSE_DIR="../discourse"

# 检查 Discourse 目录是否存在
if [ ! -d "$DISCOURSE_DIR" ]; then
    echo "❌ 错误: Discourse 目录不存在: $DISCOURSE_DIR"
    exit 1
fi

# 检查是否是 Discourse 目录
if [ ! -f "$DISCOURSE_DIR/config/database.yml" ]; then
    echo "❌ 错误: 指定的目录不是 Discourse 目录"
    exit 1
fi

echo "✅ 找到 Discourse 目录: $DISCOURSE_DIR"

# 创建插件目录
PLUGIN_DIR="$DISCOURSE_DIR/plugins/discourse-plugin-matching"
echo "📁 创建插件目录: $PLUGIN_DIR"

# 删除旧的插件目录（如果存在）
if [ -d "$PLUGIN_DIR" ]; then
    echo "🗑️  删除旧的插件目录..."
    rm -rf "$PLUGIN_DIR"
fi

# 复制插件文件
echo "📋 复制插件文件..."
cp -r . "$PLUGIN_DIR"

# 设置正确的权限
echo "🔐 设置文件权限..."
chmod -R 755 "$PLUGIN_DIR"

echo "✅ 插件部署完成！"
echo ""
echo "下一步操作："
echo "1. 进入 Discourse 目录: cd $DISCOURSE_DIR"
echo "2. 重启开发服务器: bin/docker/discourse restart"
echo "3. 或者重新构建前端: bin/docker/ember-cli"
echo "4. 或者使用快速开发脚本: ./quick-dev.sh"
echo ""
echo "插件将在重启后生效。" 