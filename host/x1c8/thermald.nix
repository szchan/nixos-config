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
