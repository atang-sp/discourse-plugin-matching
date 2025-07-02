#!/bin/bash

# Discourse Practice Matching Plugin 安装脚本

echo "开始安装 Discourse Practice Matching Plugin..."

# 检查是否在Discourse目录中
if [ ! -f "config/database.yml" ]; then
    echo "错误: 请在Discourse安装目录中运行此脚本"
    exit 1
fi

# 创建插件目录
PLUGIN_DIR="plugins/discourse-plugin-matching"
if [ -d "$PLUGIN_DIR" ]; then
    echo "警告: 插件目录已存在，将备份现有文件..."
    mv "$PLUGIN_DIR" "${PLUGIN_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
fi

mkdir -p "$PLUGIN_DIR"

# 复制插件文件
echo "复制插件文件..."
cp -r ../discourse-plugin-matching/* "$PLUGIN_DIR/"

# 设置权限
chmod +x "$PLUGIN_DIR/install.sh"

echo "插件文件已复制到 $PLUGIN_DIR"

# 提示重启Discourse
echo ""
echo "安装完成！"
echo "请执行以下步骤："
echo "1. 重启Discourse: ./launcher restart app"
echo "2. 在管理面板中启用插件"
echo "3. 运行数据库迁移（如果需要）"
echo ""
echo "插件将在重启后生效。" 