# 本机已验证的温控策略。脚本在运行时解析 hwmon，并拒绝其他机器。
{ pkgs, lib, ... }:

let
  runner = pkgs.runCommand "thermald-thinkpad-run.py" { } ''
    substitute ${./thermald-thinkpad-run.py} $out \
      --replace-fail '/usr/bin/thermald' '${pkgs.thermald}/bin/thermald'
  '';
  sleepScript = pkgs.writeShellScript "thermald-thinkpad-sleep" ''
    set -eu
    marker=/run/thermald-thinkpad-was-active
    case "$1" in
      pre)
        if ${pkgs.systemd}/bin/systemctl is-active --quiet thermald-thinkpad.service; then
          touch "$marker"
          ${pkgs.systemd}/bin/systemctl stop thermald-thinkpad.service
        else
          rm -f "$marker"
        fi
        ;;
      post)
        if test -f "$marker"; then
          rm -f "$marker"
          ${pkgs.systemd}/bin/systemctl start --no-block thermald-thinkpad.service
        fi
        ;;
      *)
        exit 2
        ;;
    esac
  '';
in
{
  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1
  '';
  boot.kernelModules = [ "thinkpad_acpi" ];

  # 自定义策略自己启动 thermald。发行版默认策略在这台机器上会直接退出。
  services.thermald.enable = false;
  services.tlp.enable = lib.mkForce false;

  # thermald 以 --dbus-enable 启动，要申请 org.freedesktop.thermald 这个总线名，
  # 而对应的 D-Bus 策略文件是由 thermald 包提供、上面那个模块负责装进
  # /etc/dbus-1/system.d 的。关掉模块后策略文件缺失，dbus-broker 默认拒绝授权，
  # thermald 只会在日志里甩一句 "Lost the name org.freedesktop.thermald" 然后
  # 以状态 1 退出，重启循环 + switch-to-configuration 报 exit 4。这里手动补上。
  services.dbus.packages = [ pkgs.thermald ];

  systemd.services.thermald-thinkpad = {
    description = "ThinkPad X1 Carbon Gen 8 thermal policy";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.python3}/bin/python3 ${runner}";
      ExecStopPost = "${pkgs.python3}/bin/python3 ${runner} --restore";
      RuntimeDirectory = "thermald-thinkpad";
      RuntimeDirectoryMode = "0700";
      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 15;
    };
  };

  systemd.services.thermald-thinkpad-sleep = {
    description = "Release ThinkPad fan control across suspend";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${sleepScript} pre";
      ExecStop = "${sleepScript} post";
    };
  };
}
