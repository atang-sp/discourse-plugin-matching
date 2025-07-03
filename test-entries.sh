#!/bin/bash

# 测试 Discourse Practice Matching Plugin 入口

echo "=== 测试插件入口 ==="
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

# 检查前端资源
echo "检查前端资源文件..."
if [ -f "plugins/discourse-plugin-matching/assets/javascripts/initializers/practice-matching.js" ]; then
    echo "✅ 前端初始化文件存在"
else
    echo "❌ 前端初始化文件不存在"
fi

if [ -f "plugins/discourse-plugin-matching/assets/stylesheets/common/practice-matching.scss" ]; then
    echo "✅ 样式文件存在"
else
    echo "❌ 样式文件不存在"
fi
echo ""

# 检查路由
echo "检查路由配置..."
if rails routes | grep -q "practice-matching"; then
    echo "✅ 后端路由已配置"
    rails routes | grep "practice-matching"
else
    echo "❌ 后端路由未配置"
fi
echo ""

# 检查插件设置
echo "检查插件设置..."
if grep -q "practice_matching_enabled" "config/site_settings.yml"; then
    echo "✅ 插件设置已配置"
else
    echo "⚠️  插件设置可能未正确配置"
fi
echo ""

echo "=== 入口位置说明 ==="
echo ""
echo "插件入口应该出现在以下位置："
echo ""
echo "1. 顶部导航栏 - 应该显示 '实践配对' 链接"
echo "2. 用户菜单 - 点击用户头像后应该看到 '实践配对管理' 选项"
echo "3. 用户资料页面 - 查看其他用户资料时应该看到 '实践配对' 按钮"
echo "4. 用户卡片 - 悬停在用户名上时应该看到 '实践配对' 按钮"
echo ""
echo "=== 测试步骤 ==="
echo ""
echo "1. 重新编译前端资源："
echo "   ./launcher rebuild app"
echo ""
echo "2. 重启Discourse："
echo "   ./launcher restart app"
echo ""
echo "3. 清除浏览器缓存并刷新页面"
echo ""
echo "4. 检查以下位置是否有插件入口："
echo "   - 顶部导航栏"
echo "   - 用户菜单（点击头像）"
echo "   - 用户资料页面"
echo "   - 用户卡片"
echo ""
echo "5. 如果入口没有显示，请检查浏览器控制台是否有错误"
echo ""
echo "=== 测试完成 ==="

echo "Testing Practice Matching Plugin Endpoints"
echo "=========================================="

# Test the main endpoint
echo "1. Testing /practice-matching endpoint..."
curl -s -X GET "http://localhost:4200/practice-matching" \
  -H "Content-Type: application/json" \
  -H "X-CSRF-Token: $(curl -s -c cookies.txt http://localhost:4200/session/csrf | grep -o 'csrf-token.*' | cut -d'"' -f3)" \
  -b cookies.txt

echo -e "\n\n2. Testing add interest endpoint..."
curl -s -X POST "http://localhost:4200/practice-matching/add" \
  -H "Content-Type: application/json" \
  -H "X-CSRF-Token: $(curl -s -c cookies.txt http://localhost:4200/session/csrf | grep -o 'csrf-token.*' | cut -d'"' -f3)" \
  -d '{"username":"testuser"}' \
  -b cookies.txt

echo -e "\n\n3. Testing remove interest endpoint..."
curl -s -X DELETE "http://localhost:4200/practice-matching/remove" \
  -H "Content-Type: application/json" \
  -H "X-CSRF-Token: $(curl -s -c cookies.txt http://localhost:4200/session/csrf | grep -o 'csrf-token.*' | cut -d'"' -f3)" \
  -d '{"username":"testuser"}' \
  -b cookies.txt

echo -e "\n\nTest completed!" 