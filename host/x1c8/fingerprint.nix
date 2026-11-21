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
  #
  # pam_fprintd 会先占住整条 PAM 会话、等手指摸上来（默认 30 秒）才轮到
  # pam_unix 提示密码；GUI 里提前输入并提交的密码会在这段等待里作废，
  # 看起来就像"密码坏了"。终端 sudo 保留默认值；登录/授权框把等待压到
  # 10 秒，不摸手指时密码提示也就晚 10 秒出现。
  security.pam.services = {
    sudo.fprintAuth = true;

    login = {
      fprintAuth = true;
      rules.auth.fprintd.settings = {
        timeout = 10;
      };
    };

    dms-greeter = {
      fprintAuth = true;
      rules.auth.fprintd.settings = {
        timeout = 10;
      };
    };

    polkit-1 = {
      fprintAuth = true;
      rules.auth.fprintd.settings = {
        timeout = 10;
      };
    };

    sshd.fprintAuth = false;
    systemd-user.fprintAuth = false;
    cups.fprintAuth = false;
  };

  # DMS 锁屏默认关闭指纹，并把密码交给外部 PAM。这里每次激活都幂等地校正：
  #   enableFprint = true               → 锁屏指纹走 DMS 自带的 assets/pam/fprint
  #   lockPamExternallyManaged = false  → 锁屏密码改用 DMS 生成的 dankshell 栈
  #                                       （里面没有 pam_fprintd，密码即时生效）
  #   greeterEnableFprint = true        → 登录界面显示"等指纹"提示（认证仍由
  #                                       greetd → login 的 PAM 栈完成）
  #   greeterPamExternallyManaged = false
  # DMS 首次运行就会写出整份默认 settings.json（enableFprint:false），所以
  # 不能只在键不存在时写一次——那正是旧写法失效的原因。
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
          printf '%s\n' '{}' > "$target"
        fi

        tmp="$(mktemp)"
        ${lib.getExe pkgs.jq} -S \
          '.enableFprint = true
           | .lockPamExternallyManaged = false
           | .greeterEnableFprint = true
           | .greeterPamExternallyManaged = false' "$target" > "$tmp"
        if cmp -s "$tmp" "$target"; then
          rm -f "$tmp"
        else
          mv "$tmp" "$target"
        fi
      '';
}
