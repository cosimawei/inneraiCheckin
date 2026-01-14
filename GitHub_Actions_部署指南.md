# GitHub Actions 自动签到部署指南

## 📋 部署步骤

### 第一步：创建 GitHub 仓库

1. 登录你的 GitHub 账号
2. 点击右上角的 `+` 号，选择 `New repository`
3. 填写仓库信息：
   - **Repository name**: `innerai-check-in`（或任意名称）
   - **Description**: `InnerAI 自动签到工具`
   - **可见性**: 选择 `Private`（私有仓库，保护你的配置信息）
4. 点击 `Create repository`

---

### 第二步：上传项目代码

在项目目录下打开命令行（PowerShell 或 CMD），执行以下命令：

```bash
cd E:\Tools\innerai-check-in

# 初始化 Git 仓库
git init

# 添加所有文件（.env 文件会被 .gitignore 忽略，不会上传）
git add .

# 创建第一次提交
git commit -m "Initial commit: InnerAI 自动签到项目"

# 关联远程仓库（替换为你的 GitHub 用户名和仓库名）
git remote add origin https://github.com/你的用户名/innerai-check-in.git

# 推送到 GitHub
git branch -M main
git push -u origin main
```

**注意**：如果提示需要登录，请使用 GitHub Personal Access Token。

---

### 第三步：配置 GitHub Secrets

1. 在你的 GitHub 仓库页面，点击 `Settings`（设置）
2. 在左侧菜单找到 `Environments`
3. 点击 `New environment`，创建名为 `production` 的环境
4. 进入 `production` 环境配置页面
5. 点击 `Add environment secret` 添加以下配置：

#### 必需配置：

**Secret Name**: `ANYROUTER_ACCOUNTS`
**Value**:
```json
[{"name":"InnerAI账号","provider":"innerai","cookies":{"session":"你的session值"},"api_user":"你的api_user值"}]
```

**注意**：
- JSON 必须是**单行格式**，不能换行
- 将 `你的session值` 替换为你从 innerai.net 获取的 session cookie
- 将 `你的api_user值` 替换为你的 API User ID（通常是 5 位数字）

#### 可选配置：

**Secret Name**: `PROVIDERS`
**Value**:
```json
{"innerai":{"domain":"https://innerai.net"}}
```

---

### 第四步：启用 GitHub Actions

1. 在仓库页面点击 `Actions` 标签
2. 如果提示启用 Actions，点击 `I understand my workflows, go ahead and enable them`
3. 找到 `InnerAI 自动签到` workflow
4. 点击 `Enable workflow`

---

### 第五步：测试运行

1. 在 `Actions` 页面，点击左侧的 `InnerAI 自动签到`
2. 点击右侧的 `Run workflow` 按钮
3. 选择 `main` 分支
4. 点击绿色的 `Run workflow` 按钮
5. 等待几秒钟，刷新页面查看运行结果

---

## ⏰ 自动运行时间

配置完成后，GitHub Actions 会：
- **每 6 小时自动运行一次**（北京时间：0点、6点、12点、18点）
- 你也可以随时手动触发运行

---

## 📊 查看运行日志

1. 进入 `Actions` 页面
2. 点击任意一次运行记录
3. 点击 `checkin` 查看详细日志
4. 可以看到签到结果、余额信息等

---

## 🔔 配置通知（可选）

如果想收到签到通知，可以在 `production` 环境中添加以下 Secrets：

### 钉钉机器人
- **Name**: `DINGDING_WEBHOOK`
- **Value**: `https://oapi.dingtalk.com/robot/send?access_token=xxx`

### 企业微信
- **Name**: `WEIXIN_WEBHOOK`
- **Value**: `https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxx`

### Telegram
- **Name**: `TELEGRAM_BOT_TOKEN`
- **Value**: `your_bot_token`
- **Name**: `TELEGRAM_CHAT_ID`
- **Value**: `your_chat_id`

---

## ⚠️ 注意事项

1. **Session 有效期**：Session cookie 大约 1 个月有效，过期后需要重新获取并更新 Secret
2. **私有仓库**：建议使用私有仓库，避免泄露你的配置信息
3. **运行时间**：GitHub Actions 的定时任务可能会延迟 5-15 分钟
4. **免费额度**：GitHub 免费账户每月有 2000 分钟的 Actions 运行时间，足够使用

---

## 🔧 故障排除

### 问题 1：Actions 运行失败
- 检查 `ANYROUTER_ACCOUNTS` 配置是否正确
- 确认 JSON 格式是单行，没有换行
- 查看运行日志中的具体错误信息

### 问题 2：401 错误
- Session cookie 已过期
- 重新获取 session 并更新 Secret

### 问题 3：找不到签到接口
- 检查 `PROVIDERS` 配置是否正确
- 确认 innerai.net 的 API 路径

---

## 📞 需要帮助？

如果遇到问题，请：
1. 查看 Actions 运行日志
2. 检查配置是否正确
3. 确认 session 和 api_user 是否有效
