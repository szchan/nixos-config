# Astryx CLI。
#
# 不维护任何哈希：依赖 tarball 由 deps.nix 从上游 pnpm-lock.yaml 的 integrity
# 生成，安装阶段把锁文件里的 resolution 指到这些本地文件，pnpm 离线完成安装。
# 上游更新后 `nix flake update astryx` 重建即可，没有额外步骤。
{
  lib,
  pkgs,
  stdenv,
  nodejs,
  pnpm,
  yq-go,
  jq,
  makeBinaryWrapper,
  repo,
}:

let
  cliRoot = repo + "/packages/cli";
  upstream = lib.importJSON (cliRoot + "/package.json");
  deps = import ./deps.nix { inherit lib pkgs repo; };
in
stdenv.mkDerivation {
  pname = "astryx";
  version = upstream.version;

  src = repo;

  nativeBuildInputs = [
    nodejs
    pnpm
    yq-go
    jq
    makeBinaryWrapper
  ];

  configurePhase = ''
    runHook preConfigure

    # 把锁文件里需要的那批包指向 Nix 预取的本地 tarball。这样安装阶段不需要
    # 网络，也不需要 store 哈希；不在集合里的包保留原来的 resolution。
    cp ${deps.lockJson} pnpm-lock.json
    jq --slurpfile m ${deps.tarballMap} '
      .packages |= with_entries(
        if $m[0][.key] then .value.resolution += { tarball: $m[0][.key] } else . end
      )
    ' pnpm-lock.json > pnpm-lock.patched.json
    yq -p=json -o=yaml '.' pnpm-lock.patched.json > pnpm-lock.yaml

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    export HOME="$TMPDIR/home"
    mkdir -p "$HOME"
    # 锁里的 tarball 指向本地文件，pnpm 12 默认拒绝这种 resolution，需要显式信任；
    # 同时关掉 pnpm 按 packageManager 字段自举版本的行为（构建期没有网络）。
    export pnpm_config_trust_lockfile=true
    export pnpm_config_pm_on_fail=ignore
    export pnpm_config_manage_package_manager_versions=false

    pnpm install --frozen-lockfile --ignore-scripts \
      --filter=@astryxdesign/cli --prod

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dest="$out/share/astryx"
    mkdir -p "$dest" "$out/bin"
    # pnpm 的 packages/cli/node_modules 里是相对符号链接，指向
    # ../../../node_modules/.pnpm/**，所以两者必须保持 workspace 的同层布局。
    mkdir -p "$dest/packages"
    cp -a packages/cli "$dest/packages/"
    cp -a node_modules "$dest/"

    makeWrapper ${nodejs}/bin/node "$out/bin/astryx" \
      --add-flags "$dest/packages/cli/clients/cli/bin/astryx.mjs"
    ln -s astryx "$out/bin/cli"

    runHook postInstall
  '';

  meta = {
    description = "Astryx command-line interface";
    homepage = "https://github.com/meta/astryx";
    license = lib.licenses.mit;
    mainProgram = "astryx";
  };
}
