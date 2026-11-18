# 主机名、mihomo 的机器差异，以及 szchan 会话里的代理环境变量。
# 共用的 mihomo 版本、tunMode 和 webui 在 base/networking.nix。
{ ... }:

{
  networking.hostName = "szchan-thinkpad-nixos";

  services.mihomo = {
    configFile = "/etc/mihomo/config.yaml";
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

    # 局域网 / 链路本地 / mDNS 不走代理。缺了这段时，凡是读代理环境变量的
    # 程序（LocalSend 的 reqwest、curl、git 等）都会把局域网请求发给 mihomo；
    # mihomo 拨 IPv6 link-local 没有 scope id，会失败并断开连接。
    no_proxy = "localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,169.254.0.0/16,fe80::/10,fc00::/7,.local,.internal";
    NO_PROXY = "localhost,127.0.0.1,::1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,169.254.0.0/16,fe80::/10,fc00::/7,.local,.internal";
  };
}
