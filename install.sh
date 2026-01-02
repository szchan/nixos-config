#!/usr/bin/env bash
set -euo pipefail  # 遇到错误立即退出，防止半途而废

# === 配置区 === #
# 你的 flake 名称（nixosConfigurations 中的键）
HOSTNAME="szchanNixOSStation"

# disko 配置文件相对路径（相对于 repo 根目录）
DISKO_CONFIG="./disko/disko-config.nix"

# 目标磁盘（安装时会完全擦除！务必确认正确）
# 如果是物理机，通常是 /dev/nvme0n1 或 /dev/sda
# 如果是虚拟机测试，通常是 /dev/vda
DISK="/dev/nvme0n1"  # <--- 请根据实际情况修改 !!!

echo "警告：此脚本将完全擦除 $DISK 并安装 NixOS 到 $HOSTNAME"
echo "磁盘: $DISK"
echo "主机名: $HOSTNAME"
read -p "确认无误？输入 yes 继续: " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "已取消安装"
    exit 1
fi

echo "=== 1. 分区、格式化、挂载 (disko) ==="
sudo nix --experimental-features "nix-command flakes" \
    run github:nix-community/disko/latest -- \
    --mode destroy,format,mount \
    "$DISKO_CONFIG" \
    --arg disk "{ main = \"$DISK\"; }"

echo "=== 2. 生成 hardware-configuration.nix ==="
sudo nixos-generate-config --no-filesystems --root /mnt

echo "=== 3. 复制整个配置到目标系统 ==="
sudo cp -r ./* /mnt/etc/nixos

echo "=== 4. 执行 nixos-install ==="
sudo nixos-install --flake "/mnt/etc/nixos#$HOSTNAME" --no-root-password

echo "=== 安装完成！==="
echo "请重启系统：sudo reboot"
echo "重启后首次登录可能需要设置用户密码"