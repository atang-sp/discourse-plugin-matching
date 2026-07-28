# Discourse Practice Matching Plugin

> **维护模式**：此插件不再接受新功能。新的兴趣推荐与一对一实践邀请将由
> `where-is-my-friends` 提供；本仓库仅保留安全修补和迁移支持。

这是旧版实践配对数据的只读查看插件。新的兴趣推荐和实践邀请请使用
`where-is-my-friends`。

## 功能特点

- **只读历史**：用户只能查看自己的旧兴趣和历史双向匹配
- **私密意向**：单向指向用户的兴趣不会向该用户或其他成员公开
- **迁移入口**：页面明确引导到 `where-is-my-friends`
- **维护边界**：不再创建、删除或通知新的配对

## 安装

1. 将插件代码复制到你的Discourse安装目录的 `plugins` 文件夹中
2. 重启Discourse
3. 在管理面板中启用插件

### 快速安装

```bash
# 在 Discourse 目录中运行
./install.sh
```

### 故障排除

如果遇到"该页面不存在"的问题，请运行：

```bash
# 快速修复路由问题
./fix-routes.sh

# 详细故障排除
./troubleshoot.sh
```

更多故障排除信息请查看 [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

## 本地开发

### 快速开始

1. **设置 Discourse 开发环境**：
   ```bash
   git clone https://github.com/discourse/discourse.git
   cd discourse
   bundle install
   yarn install
   createdb discourse_development
   rails db:migrate RAILS_ENV=development
   ```

2. **安装插件**：
   ```bash
   cp -r /path/to/discourse-practice-matching plugins/discourse-plugin-matching
   ```

3. **启动开发服务器**：
   ```bash
   ./quick-dev.sh
   ```

### 开发工具

- **快速启动**: `./quick-dev.sh` - 一键启动开发环境
- **详细设置**: `./setup-dev.sh` - 完整的环境设置
- **调试插件**: `./debug-plugin.sh` - 专门的调试工具

### 开发工作流

1. 修改代码（支持热重载）
2. 在浏览器中测试：http://localhost:3000/practice-matching
3. 查看日志：`tail -f log/development.log`
4. 调试：打开浏览器开发者工具

详细开发指南请查看 [LOCAL_DEVELOPMENT.md](LOCAL_DEVELOPMENT.md)

## 使用方法

访问 `/practice-matching` 查看自己的旧实践兴趣和历史双向匹配。若要发起新的
一对一实践邀请，请前往 `/where-is-my-friends/interests`。

### 查看匹配
- 在实践配对管理页面可以看到：
  - 我的实践兴趣（你想约实践的人）
  - 双向匹配（双方都想约实践的人）
- 单向指向你的兴趣不会向你公开

## 技术实现

### 数据模型
- `practice_interests` 表存储用户的实践兴趣关系
- 仅保留旧数据的只读查询
- 不再执行新的双向匹配或通知

### API接口
- `GET /api/practice-matching` - 获取当前用户自己的实践兴趣和双向匹配
- `POST /api/practice-matching/add` - 已停用，返回 `410 Gone`
- `DELETE /api/practice-matching/remove` - 已停用，返回 `410 Gone`

### 历史通知兼容
- 不再创建新的配对通知
- 使用 Discourse 内置 `custom` 类型，不占用全局自定义编号
- 升级迁移只会把本插件可识别的历史 900 类型通知转为 `custom`
- 保留其他插件 `custom` 通知中的受信任跳转地址，支持与替代插件重叠发布

## 配置

在Discourse管理面板中可以配置：
- 启用/禁用实践配对功能

## 开发

### 文件结构
```
discourse-plugin-matching/
├── plugin.rb                          # 主插件文件
├── lib/
│   ├── practice_matching/
│   │   ├── engine.rb                  # 引擎和迁移
│   │   │   ├── practice_interest.rb       # 数据模型
│   │   │   └── user_extension.rb          # 用户扩展
├── app/
│   └── controllers/
│       └── practice_matching_controller.rb  # 控制器
├── assets/
│   ├── javascripts/
│   │   ├── initializers/
│   │   │   └── practice-matching.js   # 前端初始化
│   │   ├── discourse/
│   │   │   ├── routes/
│   │   │   │   └── practice-matching.js     # 路由
│   │   │   ├── controllers/
│   │   │   │   └── practice-matching.js     # 控制器
│   │   │   └── templates/
│   │   │       └── practice-matching.hbs    # 模板
│   └── stylesheets/
│       └── common/
│           └── practice-matching.scss       # 样式
├── config/
│   └── settings.yml                   # 配置
└── README.md                          # 说明文档
```

### 维护边界

- 仅接受安全修补、兼容性修补和迁移支持
- 新的一对一实践邀请功能在 `where-is-my-friends` 中开发
- 不在本插件中新增字段、通知类型、界面功能或外部集成

## 许可证

MIT License

## 贡献

仅接受安全、兼容性和迁移相关的 Issue 与 Pull Request。
