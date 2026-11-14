# ThinkPad X1 Carbon Gen 8 安装备忘录

用最新的 NixOS 安装镜像启动后再做。这些命令会清空整块内置硬盘 `/dev/nvme0n1`，现在的系统会被覆盖。在正在使用的系统里不要运行。

安装配置名是 `x1c8`。装好后的主机名是 `szchan-thinkpad-nixos`。

## 1. 联网

图形安装界面直接连接 Wi-Fi。命令行安装介质：

```bash
sudo nmcli device wifi connect '你的Wi-Fi名' password '你的Wi-Fi密码'
```

## 2. 确认硬盘

内置硬盘必须叫 `nvme0n1`。名字不同就停下来，不要继续。

```bash
lsblk
```

## 3. 取出配置并生成本机硬件扫描

```bash
git clone https://github.com/szchan/nixos-config.git
cd nixos-config
sudo nixos-generate-config --no-filesystems --show-hardware-config > host/x1c8/hardware-configuration.nix
git add host/x1c8/hardware-configuration.nix
```

打开 `host/x1c8/hardware-configuration.nix` 看一眼。里面应有内核模块，不应有 `fileSystems` 或 `swapDevices`。分区由 disko 负责。

## 4. 分区并加密

脚本会要求设置磁盘密码。这个密码每次开机都要输入，指纹不能代替它。

```bash
nix --extra-experimental-features 'nix-command flakes' build .#nixosConfigurations.x1c8.config.system.build.diskoScript
sudo ./result
```

## 5. 安装系统并设置登录密码

安装结束时先给 root 设密码。然后给日常用户 `szchan` 设登录密码。

```bash
sudo nixos-install --flake .#x1c8
sudo nixos-enter --root /mnt
passwd szchan
exit
sudo reboot
```

重启前拔掉安装介质。开机输入磁盘密码，再用 `szchan` 登录。

## 6. 登录后录入指纹

```bash
sudo fprintd-enroll
```

## 7. 把硬件扫描放回仓库

确认新系统能启动后，把安装时生成的 `host/x1c8/hardware-configuration.nix` 提交并推送。以后从 GitHub 更新系统时需要这个文件。
