# Discourse Practice Matching Plugin

一个Discourse插件，允许用户添加想约实践的人，当双方都想和对方约实践时通知两人。

## 功能特点

- **添加实践兴趣**: 用户可以添加想约实践的用户到列表中
- **双向匹配检测**: 当双方都想和对方约实践时自动检测
- **实时通知**: 发现双向匹配时立即通知两个用户
- **用户界面**: 提供直观的管理界面
- **权限控制**: 只有用户本人和管理员可以管理实践兴趣

## 安装

1. 将插件代码复制到你的Discourse安装目录的 `plugins` 文件夹中
2. 重启Discourse
3. 在管理面板中启用插件

## 使用方法

### 添加实践兴趣
1. 访问用户资料页面或用户卡片
2. 点击"实践配对"按钮
3. 在管理页面点击"添加用户到实践兴趣列表"
4. 输入用户名并确认

### 查看匹配
- 在实践配对管理页面可以看到：
  - 我的实践兴趣（你想约实践的人）
  - 想和我约实践的人
  - 双向匹配（双方都想约实践的人）

### 移除实践兴趣
- 在实践兴趣列表中点击"移除"按钮

## 技术实现

### 数据模型
- `practice_interests` 表存储用户的实践兴趣关系
- 支持双向匹配检测
- 自动通知系统

### API接口
- `GET /practice-matching` - 获取用户的实践配对数据
- `POST /practice-matching/add` - 添加实践兴趣
- `DELETE /practice-matching/remove` - 移除实践兴趣

### 通知系统
- 当检测到双向匹配时自动发送通知
- 通知类型：`practice_match_found`

## 配置

在Discourse管理面板中可以配置：
- 启用/禁用实践配对功能

## 开发

### 文件结构
```
discourse-practice-matching/
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

### 自定义开发
1. 修改数据模型以添加更多字段
2. 扩展通知系统以支持更多通知类型
3. 添加更多用户界面功能
4. 集成其他Discourse功能

## 许可证

MIT License

## 贡献

欢迎提交Issue和Pull Request来改进这个插件。 