#!/bin/bash

# Discourse Practice Matching Plugin 故障排除脚本

echo "=== Discourse Practice Matching Plugin 故障排除 ==="
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

# 检查设置
echo "检查插件设置..."
if grep -q "practice_matching_enabled" "config/site_settings.yml"; then
    echo "✅ 插件设置已配置"
else
    echo "⚠️  插件设置可能未正确配置"
fi
echo ""

# 检查数据库迁移
echo "检查数据库迁移..."
if rails runner "puts PracticeMatching::PracticeInterest.table_exists?" 2>/dev/null | grep -q "true"; then
    echo "✅ 数据库表已创建"
else
    echo "❌ 数据库表未创建，需要运行迁移"
    echo "请运行: rails db:migrate"
fi
echo ""

# 检查路由
echo "检查路由配置..."
if grep -q "practice-matching" "config/routes.rb"; then
    echo "✅ 后端路由已配置"
else
    echo "⚠️  后端路由可能未正确配置"
fi
echo ""

# 检查前端资源
echo "检查前端资源..."
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

# 提供解决方案
echo "=== 解决方案 ==="
echo ""
echo "如果页面显示'该页面不存在'，请按以下步骤操作："
echo ""
echo "1. 重新编译前端资源："
echo "   ./launcher rebuild app"
echo ""
echo "2. 重启Discourse："
echo "   ./launcher restart app"
echo ""
echo "3. 清除浏览器缓存并刷新页面"
echo ""
echo "4. 检查浏览器控制台是否有JavaScript错误"
echo ""
echo "5. 确认插件已在管理面板中启用"
echo ""
echo "6. 检查用户权限（需要登录用户）"
echo ""
echo "如果问题仍然存在，请检查Discourse日志："
echo "   ./launcher logs app"
echo ""
echo "=== 故障排除完成 ===" 