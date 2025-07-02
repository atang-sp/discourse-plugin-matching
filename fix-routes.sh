#!/bin/bash

# 快速修复 Discourse Practice Matching Plugin 路由问题

echo "=== 快速修复路由问题 ==="
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

# 步骤1: 重新编译前端资源
echo "步骤 1: 重新编译前端资源..."
./launcher rebuild app
if [ $? -eq 0 ]; then
    echo "✅ 前端资源重新编译成功"
else
    echo "❌ 前端资源重新编译失败"
    exit 1
fi
echo ""

# 步骤2: 重启Discourse
echo "步骤 2: 重启Discourse..."
./launcher restart app
if [ $? -eq 0 ]; then
    echo "✅ Discourse重启成功"
else
    echo "❌ Discourse重启失败"
    exit 1
fi
echo ""

# 步骤3: 等待服务启动
echo "步骤 3: 等待服务启动..."
sleep 10
echo "✅ 等待完成"
echo ""

# 步骤4: 检查路由
echo "步骤 4: 检查路由配置..."
if rails routes | grep -q "practice-matching"; then
    echo "✅ 后端路由配置正确"
else
    echo "❌ 后端路由配置有问题"
fi
echo ""

# 步骤5: 检查插件设置
echo "步骤 5: 检查插件设置..."
if grep -q "practice_matching_enabled" "config/site_settings.yml"; then
    echo "✅ 插件设置已配置"
else
    echo "⚠️  插件设置可能未正确配置"
fi
echo ""

echo "=== 修复完成 ==="
echo ""
echo "现在请尝试访问: https://你的论坛域名/practice-matching"
echo ""
echo "如果仍然有问题，请："
echo "1. 清除浏览器缓存"
echo "2. 检查浏览器控制台错误"
echo "3. 确认用户已登录"
echo "4. 在管理面板中确认插件已启用"
echo ""
echo "如果问题持续，请运行: ./troubleshoot.sh" 