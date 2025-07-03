#!/bin/bash

# 修复 Discourse Practice Matching Plugin 路由问题

echo "=== 修复路由问题 ==="
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

# 步骤1: 检查后端路由
echo "步骤 1: 检查后端路由..."
if rails routes | grep -q "practice-matching"; then
    echo "✅ 后端路由已配置"
    rails routes | grep "practice-matching"
else
    echo "❌ 后端路由未配置"
    echo "请检查 plugin.rb 文件中的路由配置"
fi
echo ""

# 步骤2: 检查前端文件
echo "步骤 2: 检查前端文件..."
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

if [ -f "plugins/discourse-plugin-matching/assets/javascripts/initializers/practice-matching.js" ]; then
    echo "✅ 前端初始化文件存在"
else
    echo "❌ 前端初始化文件不存在"
fi
echo ""

# 步骤3: 重新编译前端资源
echo "步骤 3: 重新编译前端资源..."
./launcher rebuild app
if [ $? -eq 0 ]; then
    echo "✅ 前端资源重新编译成功"
else
    echo "❌ 前端资源重新编译失败"
    exit 1
fi
echo ""

# 步骤4: 重启Discourse
echo "步骤 4: 重启Discourse..."
./launcher restart app
if [ $? -eq 0 ]; then
    echo "✅ Discourse重启成功"
else
    echo "❌ Discourse重启失败"
    exit 1
fi
echo ""

# 步骤5: 等待服务启动
echo "步骤 5: 等待服务启动..."
sleep 15
echo "✅ 等待完成"
echo ""

# 步骤6: 检查服务状态
echo "步骤 6: 检查服务状态..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/ | grep -q "200\|302"; then
    echo "✅ Discourse服务正常运行"
else
    echo "⚠️  Discourse服务可能未完全启动"
fi
echo ""

echo "=== 修复完成 ==="
echo ""
echo "现在请尝试访问: https://你的论坛域名/practice-matching"
echo ""
echo "如果仍然有问题，请："
echo "1. 清除浏览器缓存"
echo "2. 检查浏览器控制台错误"
echo "3. 检查Discourse日志: ./launcher logs app"
echo "4. 确认用户已登录"
echo ""
echo "调试信息："
echo "- 后端路由: rails routes | grep practice-matching"
echo "- 前端路由: 检查浏览器控制台"
echo "- 服务状态: ./launcher status" 