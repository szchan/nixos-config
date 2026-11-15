# LocalSend 1.18.0 的 autoPatchelf 只把直接 GTK/GLib 依赖写进 RUNPATH，
# 漏掉了 zlib。二进制本身 NEEDED libz.so.1，于是启动即在加载器阶段失败：
#   localsend_app: error while loading shared libraries: libz.so.1: cannot open shared object file
# 这里不改包体内容，只在外面套一层 wrapper，把 zlib 加进 LD_LIBRARY_PATH。
# 这样无需重新编译整个 Flutter 应用；等上游修好后删掉本 overlay 即可。
final: prev: {
  localsend = prev.symlinkJoin {
    name = "localsend-${prev.localsend.version}-zlib";
    paths = [ prev.localsend ];
    nativeBuildInputs = [ prev.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/localsend_app \
        --prefix LD_LIBRARY_PATH : ${final.zlib}/lib
    '';
  };
}
