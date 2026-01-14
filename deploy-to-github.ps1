# InnerAI 自动签到 - GitHub 部署脚本
# 使用方法: .\deploy-to-github.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  InnerAI 自动签到 - GitHub 部署工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否已经初始化 Git
if (-not (Test-Path ".git")) {
    Write-Host "[1/5] 初始化 Git 仓库..." -ForegroundColor Yellow
    git init
    Write-Host "✅ Git 仓库初始化完成" -ForegroundColor Green
} else {
    Write-Host "[1/5] Git 仓库已存在，跳过初始化" -ForegroundColor Green
}

Write-Host ""

# 获取 GitHub 仓库地址
Write-Host "[2/5] 配置远程仓库" -ForegroundColor Yellow
$remoteUrl = git remote get-url origin 2>$null

if ($remoteUrl) {
    Write-Host "当前远程仓库: $remoteUrl" -ForegroundColor Cyan
    $change = Read-Host "是否更改远程仓库地址? (y/N)"
    if ($change -eq "y" -or $change -eq "Y") {
        $newUrl = Read-Host "请输入新的 GitHub 仓库地址 (例如: https://github.com/username/repo.git)"
        git remote set-url origin $newUrl
        Write-Host "✅ 远程仓库地址已更新" -ForegroundColor Green
    }
} else {
    Write-Host "请输入你的 GitHub 仓库地址" -ForegroundColor Cyan
    Write-Host "格式: https://github.com/你的用户名/仓库名.git" -ForegroundColor Gray
    $repoUrl = Read-Host "仓库地址"

    if ($repoUrl) {
        git remote add origin $repoUrl
        Write-Host "✅ 远程仓库配置完成" -ForegroundColor Green
    } else {
        Write-Host "❌ 未输入仓库地址，退出部署" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""

# 添加文件
Write-Host "[3/5] 添加项目文件..." -ForegroundColor Yellow
git add .
Write-Host "✅ 文件添加完成" -ForegroundColor Green

Write-Host ""

# 提交
Write-Host "[4/5] 创建提交..." -ForegroundColor Yellow
$commitMsg = Read-Host "请输入提交信息 (直接回车使用默认信息)"
if (-not $commitMsg) {
    $commitMsg = "Update: InnerAI 自动签到配置"
}

git commit -m $commitMsg
Write-Host "✅ 提交创建完成" -ForegroundColor Green

Write-Host ""

# 推送
Write-Host "[5/5] 推送到 GitHub..." -ForegroundColor Yellow
git branch -M main
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ✅ 部署成功！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "下一步操作：" -ForegroundColor Cyan
    Write-Host "1. 访问你的 GitHub 仓库" -ForegroundColor White
    Write-Host "2. 进入 Settings -> Environments" -ForegroundColor White
    Write-Host "3. 创建 production 环境" -ForegroundColor White
    Write-Host "4. 添加 ANYROUTER_ACCOUNTS 配置" -ForegroundColor White
    Write-Host "5. 启用 GitHub Actions" -ForegroundColor White
    Write-Host ""
    Write-Host "详细步骤请查看: GitHub_Actions_部署指南.md" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "❌ 推送失败，请检查：" -ForegroundColor Red
    Write-Host "1. GitHub 仓库地址是否正确" -ForegroundColor White
    Write-Host "2. 是否有推送权限" -ForegroundColor White
    Write-Host "3. 是否需要配置 Personal Access Token" -ForegroundColor White
}

Write-Host ""
Read-Host "按回车键退出"
