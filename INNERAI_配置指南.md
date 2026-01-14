# InnerAI.net 签到配置指南

## 📌 第一步：获取必要信息

### 1.1 获取 Session Cookie

1. 打开浏览器访问 https://innerai.net/
2. 登录你的账号
3. 按 `F12` 打开开发者工具
4. 切换到 **Application** 标签（Chrome）或 **存储** 标签（Firefox）
5. 左侧找到 **Cookies** → **https://innerai.net**
6. 找到名为 `session` 的 cookie
7. 复制它的 **Value** 值（通常是一长串字符）

### 1.2 获取 API User ID

1. 在开发者工具中切换到 **Network** 标签
2. 刷新页面或点击任意功能
3. 在左侧筛选器中选择 **Fetch/XHR**
4. 点击任意一个请求
5. 查看 **Headers** → **Request Headers**
6. 找到 `New-Api-User` 或 `new-api-user` 字段
7. 复制它的值（通常是 5 位数字，如 12345）

**注意**：如果该值是负数或个位数，说明未正确登录，请重新登录后再获取。

---

## 📝 第二步：修改配置文件

打开项目目录下的 `.env` 文件，修改以下内容：

### 2.1 基础配置（必填）

```bash
# 将下面的值替换为你实际获取的值
ANYROUTER_ACCOUNTS=[{"name":"InnerAI账号","provider":"innerai","cookies":{"session":"你的session值"},"api_user":"你的api_user值"}]
```

**示例**：
```bash
ANYROUTER_ACCOUNTS=[{"name":"我的主账号","provider":"innerai","cookies":{"session":"abc123xyz789..."},"api_user":"12345"}]
```

### 2.2 Provider 配置

默认配置应该可以工作：
```bash
PROVIDERS={"innerai":{"domain":"https://innerai.net"}}
```

**如果签到失败**，可能需要调整配置。根据 innerai.net 的实际情况，可能需要：

```bash
# 完整配置示例（根据实际情况调整）
PROVIDERS={"innerai":{"domain":"https://innerai.net","sign_in_path":"/api/user/sign_in","user_info_path":"/api/user/self","api_user_key":"new-api-user","bypass_method":"waf_cookies","waf_cookie_names":["acw_tc"]}}
```

---

## 🚀 第三步：安装依赖并运行

### 3.1 安装依赖

```bash
cd innerai-check-in
uv sync --dev
uv run playwright install chromium
```

### 3.2 测试运行

```bash
uv run checkin.py
```

---

## 📊 预期结果

成功运行后，你应该看到类似输出：

```
[INFO] Loaded 1 custom provider(s) from PROVIDERS environment variable
[PROCESSING] InnerAI账号: Starting sign-in process...
[SUCCESS] InnerAI账号: Sign-in successful! Balance: $XX.XX
```

---

## ⚠️ 常见问题

### 问题 1：401 错误
**原因**：Session cookie 已过期
**解决**：重新获取 session cookie 并更新 `.env` 文件

### 问题 2：找不到签到接口
**原因**：innerai.net 的 API 路径可能不同
**解决**：
1. 在浏览器开发者工具的 Network 标签中
2. 手动点击签到按钮
3. 查看实际调用的 API 路径
4. 更新 PROVIDERS 配置中的 `sign_in_path`

### 问题 3：WAF 拦截
**原因**：网站有防火墙保护
**解决**：在 PROVIDERS 配置中添加：
```bash
"bypass_method":"waf_cookies","waf_cookie_names":["acw_tc","cdn_sec_tc"]
```

---

## 🔔 可选：配置通知

如果想收到签到通知，可以在 `.env` 中配置以下任意一种：

### 钉钉机器人
```bash
DINGDING_WEBHOOK=https://oapi.dingtalk.com/robot/send?access_token=xxx
```

### 企业微信
```bash
WEIXIN_WEBHOOK=https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=xxx
```

### Telegram
```bash
TELEGRAM_BOT_TOKEN=your_bot_token
TELEGRAM_CHAT_ID=your_chat_id
```

---

## 🤖 部署到 GitHub Actions（自动签到）

如果想实现每天自动签到，参考主 README.md 的 GitHub Actions 配置部分。

---

## 📞 需要帮助？

如果遇到问题，请检查：
1. Session cookie 是否正确且未过期
2. API User ID 是否正确（应该是正数）
3. innerai.net 的 API 接口是否与默认配置一致
4. 查看运行日志中的详细错误信息
