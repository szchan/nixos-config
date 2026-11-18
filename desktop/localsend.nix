# LocalSend。启动问题由下面的 overlay 修复；overlay 在这里应用，
# 系统服务和 home-manager 装的是同一份 pkgs。
{ ... }:

{
  # 两个问题都在这一层 wrapper 里补掉：不改包体、不重编 Flutter 应用。
  #
  # 1) 启动失败。localsend 1.18.0 的 autoPatchelf 只把直接 GTK/GLib 依赖写进
  #    RUNPATH，漏了 zlib。二进制 NEEDED libz.so.1，于是加载器阶段就失败：
  #      localsend_app: error while loading shared libraries: libz.so.1: cannot open shared object file
  #    → 把 zlib 加进 LD_LIBRARY_PATH。
  #
  # 2) 发送失败（tls handshake eof）。LocalSend 的 Rust 客户端用 reqwest，
  #    并且开了 system-proxy，会读 HTTP(S)_PROXY / ALL_PROXY。本机会话里这些
  #    变量指向 mihomo，于是发文件时的 HTTPS 请求被送进代理；而收件人若是
  #    IPv6 link-local（fe80::…%4 被编码成 fe80--…s4.scoped.localsend.internal），
  #    代理拿不到 scope id，拨号直接报 “connect: invalid argument” 并把连接断掉，
  #    客户端只看到 “tls handshake eof”。LocalSend 只跟局域网设备通信，不需要代理，
  #    所以这里清掉代理变量让它直连（直连时 reqwest 的自定义 resolver 会还原 scope id）。
  #
  # 等上游修好后删掉这段 overlay 即可。
  nixpkgs.overlays = [
    (final: prev: {
      localsend = prev.symlinkJoin {
        name = "localsend-${prev.localsend.version}-zlib";
        paths = [ prev.localsend ];
        nativeBuildInputs = [ prev.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/localsend_app \
            --prefix LD_LIBRARY_PATH : ${final.zlib}/lib \
            --unset http_proxy --unset https_proxy --unset all_proxy \
            --unset ftp_proxy --unset socks_proxy \
            --unset HTTP_PROXY --unset HTTPS_PROXY --unset ALL_PROXY \
            --unset FTP_PROXY --unset SOCKS_PROXY
        '';
      };
    })
  ];

  programs.localsend = {
    enable = true;
    openFirewall = true;
  };
}
