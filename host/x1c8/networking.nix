# 主机名、本机代理服务，以及 szchan 会话里的代理环境变量。
{ pkgs, ... }:

{
  networking.hostName = "szchan-thinkpad-nixos";

  # programs.clash-verge = {
  #   enable = true;
  #   serviceMode = true;
  #   tunMode = true;
  # };

  services.mihomo = {
    enable = true;
    package = pkgs.mihomo;
    configFile = "/etc/mihomo/config.yaml";
    tunMode = true;
    webui = pkgs.metacubexd;
  };

  # 与当前 Bash 的本机代理一致。mihomo 监听 127.0.0.1:7897。
  home-manager.users.szchan.home.sessionVariables = {
    http_proxy = "http://127.0.0.1:7897";
    https_proxy = "http://127.0.0.1:7897";
    HTTP_PROXY = "http://127.0.0.1:7897";
    HTTPS_PROXY = "http://127.0.0.1:7897";
    all_proxy = "socks5://127.0.0.1:7897";
    ALL_PROXY = "socks5://127.0.0.1:7897";
    ftp_proxy = "http://127.0.0.1:7897";
    FTP_PROXY = "http://127.0.0.1:7897";
    socks_proxy = "socks5://127.0.0.1:7897";
    SOCKS_PROXY = "socks5://127.0.0.1:7897";
  };
}
