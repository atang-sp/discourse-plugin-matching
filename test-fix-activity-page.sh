#!/bin/bash

echo "=== 测试用户活动页面修复 ==="
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
    exit 1
fi

echo "✅ 插件已安装"
echo ""

# 检查CSS类名是否已修复
echo "步骤 1: 检查CSS类名修复..."
echo ""

echo "检查主页面模板:"
if grep -q "practice-matching-user-list" "plugins/discourse-plugin-matching/assets/javascripts/discourse/templates/practice-matching.hbs"; then
    echo "✅ 主页面使用正确的类名"
else
    echo "❌ 主页面类名未修复"
fi

echo "检查用户选择器模板:"
if grep -q "practice-matching-search-user-list" "plugins/discourse-plugin-matching/assets/javascripts/discourse/components/practice-matching-user-selector.hbs"; then
    echo "✅ 用户选择器使用正确的类名"
else
    echo "❌ 用户选择器类名未修复"
fi

echo "检查CSS文件:"
if grep -q "practice-matching-user-list" "plugins/discourse-plugin-matching/assets/stylesheets/practice-matching.scss"; then
    echo "✅ CSS文件使用正确的类名"
else
    echo "❌ CSS文件类名未修复"
fi

echo ""
echo "步骤 2: 检查是否有冲突的CSS选择器..."
echo ""

# 检查是否还有通用的.user-list选择器
if grep -q "\.user-list" "plugins/discourse-plugin-matching/assets/stylesheets/practice-matching.scss"; then
    echo "⚠️  发现可能的冲突选择器 .user-list"
    grep -n "\.user-list" "plugins/discourse-plugin-matching/assets/stylesheets/practice-matching.scss"
else
    echo "✅ 没有发现冲突的 .user-list 选择器"
fi

# 检查是否还有通用的.user-info选择器
if grep -q "\.user-info" "plugins/discourse-plugin-matching/assets/stylesheets/practice-matching.scss"; then
    echo "⚠️  发现可能的冲突选择器 .user-info"
    grep -n "\.user-info" "plugins/discourse-plugin-matching/assets/stylesheets/practice-matching.scss"
else
    echo "✅ 没有发现冲突的 .user-info 选择器"
fi

echo ""
echo "步骤 3: 检查作用域限制..."
echo ""

# 检查CSS是否都有正确的作用域
if grep -q "\.practice-matching-page" "plugins/discourse-plugin-matching/assets/stylesheets/practice-matching.scss"; then
    echo "✅ CSS有正确的作用域限制"
else
    echo "❌ CSS缺少作用域限制"
fi

echo ""
echo "=== 修复验证完成 ==="
echo ""
echo "修复内容:"
echo "1. 将 .user-list 改为 .practice-matching-user-list"
echo "2. 将弹窗中的 .user-list 改为 .practice-matching-search-user-list"
echo "3. 确保所有CSS选择器都有正确的作用域"
echo "4. 避免与Discourse其他页面的样式冲突"
echo ""
echo "现在用户活动页面应该可以正常显示了。"
echo "如果还有问题，请检查浏览器控制台的错误信息。" 