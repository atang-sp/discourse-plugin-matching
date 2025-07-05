#!/bin/bash

echo "=== 测试用户资料页面实践匹配按钮 ==="
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

# 检查文件是否存在
echo "步骤 1: 检查必要文件..."
files_to_check=(
    "plugins/discourse-plugin-matching/assets/javascripts/discourse/components/practice-matching-profile-button.js"
    "plugins/discourse-plugin-matching/assets/javascripts/discourse/components/practice-matching-profile-button.hbs"
    "plugins/discourse-plugin-matching/assets/javascripts/discourse/templates/connectors/user-profile-controls/practice-matching-button.hbs"
    "plugins/discourse-plugin-matching/assets/javascripts/initializers/practice-matching.js"
)

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file 存在"
    else
        echo "❌ $file 不存在"
    fi
done
echo ""

# 检查国际化文件
echo "步骤 2: 检查国际化文件..."
if grep -q "add_interest" "plugins/discourse-plugin-matching/config/locales/client.zh_CN.yml"; then
    echo "✅ 中文国际化文本已添加"
else
    echo "❌ 中文国际化文本未添加"
fi

if grep -q "add_interest" "plugins/discourse-plugin-matching/config/locales/client.en.yml"; then
    echo "✅ 英文国际化文本已添加"
else
    echo "❌ 英文国际化文本未添加"
fi
echo ""

# 检查样式文件
echo "步骤 3: 检查样式文件..."
if grep -q "practice-interest-btn" "plugins/discourse-plugin-matching/assets/stylesheets/practice-matching.scss"; then
    echo "✅ 按钮样式已添加"
else
    echo "❌ 按钮样式未添加"
fi
echo ""

# 检查文件内容
echo "步骤 4: 检查文件内容..."
echo ""

echo "检查组件文件:"
if grep -q "PracticeMatchingProfileButton" "plugins/discourse-plugin-matching/assets/javascripts/discourse/components/practice-matching-profile-button.js"; then
    echo "✅ 组件类名正确"
else
    echo "❌ 组件类名不正确"
fi

if grep -q "toggleInterest" "plugins/discourse-plugin-matching/assets/javascripts/discourse/components/practice-matching-profile-button.js"; then
    echo "✅ 组件方法正确"
else
    echo "❌ 组件方法不正确"
fi

echo ""
echo "检查模板文件:"
if grep -q "PracticeMatchingProfileButton" "plugins/discourse-plugin-matching/assets/javascripts/discourse/templates/connectors/user-profile-controls/practice-matching-button.hbs"; then
    echo "✅ 模板文件内容正确"
else
    echo "❌ 模板文件内容不正确"
fi

echo ""
echo "检查初始化文件:"
if grep -q "user-profile-controls" "plugins/discourse-plugin-matching/assets/javascripts/initializers/practice-matching.js"; then
    echo "✅ 插件出口点注册正确"
else
    echo "❌ 插件出口点注册不正确"
fi
echo ""

echo "=== 测试完成 ==="
echo ""
echo "现在你可以："
echo "1. 访问任意用户的资料页面"
echo "2. 查看是否显示'我想和他约实践'按钮"
echo "3. 测试按钮的添加/移除功能"
echo "4. 检查移动端显示效果"
echo ""
echo "如果遇到问题，请检查浏览器控制台的错误信息" 