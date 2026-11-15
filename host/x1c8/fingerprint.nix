# 本机的指纹登录：fprintd、PAM，以及 DMS 锁屏的指纹开关。
{
  inputs,
  lib,
  pkgs,
  ...
}:

{
  # Synaptics Prometheus，USB 06cb:00bd，由 libfprint 1.94.9 的 Synaptics 驱动支持。
  services.fprintd.enable = true;
  services.udev.packages = [ pkgs.libfprint ];

  # 指纹成功即通过，失败后仍可用密码。SSH、用户会话和打印不弹出指纹。
  security.pam.services = {
    sudo.fprintAuth = true;
    login.fprintAuth = true;
    polkit-1.fprintAuth = true;
    dms-greeter.fprintAuth = true;
    sshd.fprintAuth = false;
    systemd-user.fprintAuth = false;
    cups.fprintAuth = false;
  };

  # DMS 锁屏默认关闭指纹。只补上这个开关，文件保持可写。
  # Dux Shell 2.x 使用 ~/.config/dms，首次启动会把旧的 DankMaterialShell
  # 目录迁移过去；迁移完成前继续写旧位置，避免破坏迁移。
  home-manager.users.szchan.home.activation.dmsFingerprint =
    inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ]
      ''
        settings="$HOME/.config/dms/settings.json"
        legacy="$HOME/.config/DankMaterialShell/settings.json"

        target="$settings"
        if [ ! -e "$settings" ] && [ -e "$legacy" ]; then
          target="$legacy"
        fi

        mkdir -p "$(dirname "$target")"
        if [ ! -e "$target" ]; then
          printf '%s\n' '{"enableFprint":true}' > "$target"
        elif [ -f "$target" ] && ! ${lib.getExe pkgs.jq} -e 'has("enableFprint")' "$target" >/dev/null; then
          tmp="$(mktemp)"
          ${lib.getExe pkgs.jq} '.enableFprint = true' "$target" > "$tmp"
          mv "$tmp" "$target"
        fi
      '';
}
