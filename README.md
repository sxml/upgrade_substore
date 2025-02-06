通过VPS架设Sub-Store(新版)
https://surge.tel/08/2930/

搭建后期 升级脚本

使用说明：
将脚本保存为 upgrade_substore.sh

赋予执行权限：
chmod +x upgrade_substore.sh

一键执行：
./upgrade_substore.sh

脚本特点：
完整错误检测（使用 set -e 自动中断失败流程）

自动备份前端文件（覆盖式备份防止目录嵌套）

智能 Web 服务检测（自动识别 nginx/caddy 状态）

状态可视化（关键步骤都有进度提示）

双保险服务控制（每次操作前主动停止服务）

注意事项：
请确保所有路径与您的实际安装路径一致（默认为 /root/sub-store）

如果使用非 root 用户部署，需要调整文件路径权限

首次使用建议先测试备份恢复功能
