# 故障排除指南

## 问题：页面显示"该页面不存在或者是一个不公开页面"

### 可能的原因

1. **前端路由未正确注册**
2. **资源未重新编译**
3. **Discourse 未重启**
4. **插件未启用**
5. **数据库迁移未运行**
6. **用户权限问题**

### 解决步骤

#### 1. 检查插件安装状态

```bash
# 在 Discourse 目录中运行
ls -la plugins/discourse-plugin-matching/
```

确保插件目录存在且包含所有必要文件。

#### 2. 重新编译前端资源

```bash
# 在 Discourse 目录中运行
./launcher rebuild app
```

这将重新编译所有前端资源，包括新添加的路由。

#### 3. 重启 Discourse

```bash
# 在 Discourse 目录中运行
./launcher restart app
```

重启确保所有更改生效。

#### 4. 检查插件设置

1. 登录 Discourse 管理面板
2. 进入 "设置" > "插件"
3. 确保 "practice_matching_enabled" 设置为 "启用"

#### 5. 运行数据库迁移

```bash
# 在 Discourse 目录中运行
rails db:migrate
```

确保数据库表已创建。

#### 6. 检查用户权限

- 确保用户已登录
- 检查用户是否有访问权限
- 尝试以管理员身份访问

#### 7. 检查浏览器控制台

1. 打开浏览器开发者工具
2. 查看控制台是否有 JavaScript 错误
3. 查看网络标签页是否有 404 错误

#### 8. 检查 Discourse 日志

```bash
# 在 Discourse 目录中运行
./launcher logs app
```

查看是否有相关错误信息。

### 常见错误及解决方案

#### 错误 1: "该页面不存在"

**原因**: 前端路由未正确注册

**解决方案**:
1. 确保 `assets/javascripts/initializers/practice-matching.js` 文件存在
2. 重新编译资源: `./launcher rebuild app`
3. 重启 Discourse: `./launcher restart app`

#### 错误 2: 500 服务器错误

**原因**: 后端路由或控制器问题

**解决方案**:
1. 检查 `plugin.rb` 中的路由配置
2. 确保控制器文件存在且语法正确
3. 检查数据库迁移是否运行

#### 错误 3: 403 禁止访问

**原因**: 用户权限不足

**解决方案**:
1. 确保用户已登录
2. 检查插件设置是否启用
3. 尝试以管理员身份访问

#### 错误 4: 404 未找到

**原因**: 路由配置错误

**解决方案**:
1. 检查 `plugin.rb` 中的路由定义
2. 确保前端路由正确注册
3. 清除浏览器缓存

### 调试步骤

#### 1. 验证后端路由

```bash
# 在 Discourse 目录中运行
rails routes | grep practice-matching
```

应该看到类似输出：
```
practice_matching_index GET    /practice-matching(.:format) practice_matching#index
```

#### 2. 验证前端路由

在浏览器控制台中运行：
```javascript
Discourse.Router.router.recognizer.names
```

应该包含 `practice-matching`。

#### 3. 测试 API 端点

```bash
# 测试后端 API（需要登录）
curl -H "X-CSRF-Token: YOUR_TOKEN" https://你的论坛域名/practice-matching
```

#### 4. 检查文件权限

```bash
# 确保插件文件有正确权限
chmod -R 755 plugins/discourse-plugin-matching/
```

### 预防措施

1. **开发环境测试**: 在开发环境中充分测试后再部署
2. **版本控制**: 使用 Git 管理代码变更
3. **备份**: 部署前备份当前配置
4. **日志监控**: 定期检查 Discourse 日志
5. **用户反馈**: 收集用户反馈及时修复问题

### 获取帮助

如果问题仍然存在：

1. 检查 [Discourse 官方文档](https://docs.discourse.org/)
2. 在 [Discourse 社区](https://meta.discourse.org/) 寻求帮助
3. 查看插件 GitHub 仓库的 Issues
4. 联系插件开发者

### 相关文件

- `plugin.rb` - 主插件文件
- `assets/javascripts/initializers/practice-matching.js` - 前端初始化
- `assets/javascripts/discourse/routes/practice-matching.js` - 前端路由
- `app/controllers/practice_matching_controller.rb` - 后端控制器
- `config/settings.yml` - 插件设置 