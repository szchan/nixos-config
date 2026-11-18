# 从上游 pnpm-lock.yaml 生成 Astryx CLI 的依赖 tarball 集合。
#
# 哈希直接取锁文件里每个包的 integrity（SRI），所以不需要额外维护固定输出哈希，
# 也不需要 pnpm store 归档：上游更新后 `nix flake update astryx` 重建即可。
# 只取 CLI 这个 workspace 包的运行期依赖闭包，其余 workspace 包不下载。
{
  lib,
  pkgs,
  repo,
}:
let
  # 锁文件是 YAML，Nix 没有 YAML 解析器，所以用 IFD 转成 JSON 再求值。
  lockJson =
    pkgs.runCommand "astryx-pnpm-lock.json"
      {
        nativeBuildInputs = [ pkgs.yq-go ];
      }
      ''
        yq -o=json '.' ${repo}/pnpm-lock.yaml > $out
      '';

  lock = lib.importJSON lockJson;
  snapshots = lock.snapshots or { };
  importers = lock.importers or { };

  cliImporter = importers."packages/cli" or { };
  wanted = (cliImporter.dependencies or { }) // (cliImporter.optionalDependencies or { });

  # 锁里的依赖图是 snapshot id -> snapshot id，id 形如 name@version(peer@ver)。
  startIds = map (name: "${name}@${(wanted.${name}).version}") (builtins.attrNames wanted);

  depsOf =
    id:
    let
      snapshot = snapshots.${id} or { };
      deps = (snapshot.dependencies or { }) // (snapshot.optionalDependencies or { });
    in
    map (name: "${name}@${deps.${name}}") (builtins.attrNames deps);

  reachable = builtins.genericClosure {
    startSet = map (id: { key = id; }) startIds;
    operator = item: map (id: { key = id; }) (depsOf item.key);
  };

  # 去掉 peer 后缀，得到 packages 表里的 name@version。
  packageKeys = lib.unique (map (item: lib.head (lib.splitString "(" item.key)) reachable);

  needed = lib.filterAttrs (key: _: builtins.elem key packageKeys) (lock.packages or { });

  splitKey =
    key:
    let
      m = builtins.match "(.+)@([^@]+)" key;
    in
    {
      name = builtins.elemAt m 0;
      version = builtins.elemAt m 1;
    };

  fetchPackage =
    key: value:
    let
      inherit (splitKey key) name version;
      base = lib.last (lib.splitString "/" name);
      url = value.resolution.tarball or "https://registry.npmjs.org/${name}/-/${base}-${version}.tgz";
    in
    pkgs.fetchurl {
      inherit url;
      hash = value.resolution.integrity;
      name = "${builtins.replaceStrings [ "/" ] [ "-" ] name}-${version}.tgz";
    };

  tarballs = lib.mapAttrs fetchPackage needed;
in
{
  inherit lockJson;
  # name@version -> file:///nix/store/...，安装阶段用它把锁文件指到本地 tarball。
  tarballMap = pkgs.writeText "astryx-tarballs.json" (
    builtins.toJSON (lib.mapAttrs (_: path: "file://${path}") tarballs)
  );
}
