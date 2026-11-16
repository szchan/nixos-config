#!/usr/bin/env bash
set -euo pipefail  # 遇到错误立即退出，防止半途而废

# 原先的 NVIDIA 台式机（szchanNixOSStation）安装脚本。
# 在 NixOS 安装镜像里、仓库根目录下运行：
#
#   sudo ./host/station/install.sh
#
# 注意：disko 会清空 host/station/disko.nix 里写的磁盘 /dev/nvme0n1。
# 安装前先备份 host/station/networking.nix 里引用的 mihomo 配置。

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONFIG="szchanNixOSStation"
DISKO_LINK="/tmp/station-disko"

echo "警告：此脚本将完全擦除 host/station/disko.nix 里的磁盘，并安装 NixOS 到 $CONFIG"
echo "仓库: $REPO_ROOT"
read -p "确认无误？输入 yes 继续: " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "已取消安装"
    exit 1
fi

echo "=== 1. 分区、格式化、挂载 (disko) ==="
nix --extra-experimental-features 'nix-command flakes' build \
    "$REPO_ROOT#nixosConfigurations.$CONFIG.config.system.build.diskoScript" \
    --out-link "$DISKO_LINK"
sudo "$DISKO_LINK"

echo "=== 2. 执行 nixos-install ==="
sudo nixos-install --flake "$REPO_ROOT#$CONFIG" --no-root-password

echo "=== 安装完成！==="
echo "请重启系统：sudo reboot"
echo "重启后首次登录可能需要设置用户密码"
