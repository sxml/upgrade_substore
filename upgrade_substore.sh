#!/bin/bash

set -e

echo "=== 开始升级 Sub-Store ==="

# 升级前端
echo "=== 升级前端 ==="
echo "停止 Sub-Store 服务..."
systemctl stop sub-store.service || true

echo "备份当前前端文件..."
rm -rf /root/sub-store/frontend_backup
cp -r /root/sub-store/frontend /root/sub-store/frontend_backup

echo "下载最新前端文件..."
curl -fsSL https://github.com/sub-store-org/Sub-Store-Front-End/releases/latest/download/dist.zip -o /root/sub-store/dist.zip

if [ ! -f /root/sub-store/dist.zip ]; then
    echo "错误：前端压缩包下载失败！"
    exit 1
fi

echo "解压并替换前端文件..."
cd /root/sub-store
unzip -o dist.zip
rm -rf frontend
mv dist frontend
rm -f dist.zip

# 升级后端
echo "=== 升级后端 ==="
echo "停止 Sub-Store 服务..."
systemctl stop sub-store.service || true

echo "下载最新后端文件..."
curl -fsSL https://github.com/sub-store-org/Sub-Store/releases/latest/download/sub-store.bundle.js -o /root/sub-store/sub-store.bundle.js

if [ ! -f /root/sub-store/sub-store.bundle.js ]; then
    echo "错误：后端文件下载失败！"
    exit 1
fi

echo "重载系统服务..."
systemctl daemon-reload

echo "启动 Sub-Store 服务..."
systemctl start sub-store.service

echo "重启 Web 服务..."
# 自动检测并重启正在运行的 Web 服务
if systemctl is-active --quiet nginx; then
    echo "检测到 nginx 正在运行，正在重启..."
    systemctl restart nginx
elif systemctl is-active --quiet caddy; then
    echo "检测到 caddy 正在运行，正在重启..."
    systemctl restart caddy
else
    echo "未检测到运行的 Web 服务 (nginx/caddy)，跳过重启。"
fi

echo "查看服务状态..."
systemctl status sub-store.service

echo "=== Sub-Store 升级完成 ==="