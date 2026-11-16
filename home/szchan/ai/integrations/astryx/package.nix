{
  lib,
  stdenv,
  nodejs,
  importNpmLock,
  makeBinaryWrapper,
  repo,
}:

let
  cliRoot = repo + "/packages/cli";
  upstream = lib.importJSON (cliRoot + "/package.json");
  catalogLine = lib.findFirst (lib.hasInfix "'@stylexjs/babel-plugin':") "" (
    lib.splitString "\n" (builtins.readFile (repo + "/pnpm-workspace.yaml"))
  );
  catalogVersion = builtins.elemAt (builtins.match ".*:[[:space:]]*([^[:space:]]+).*" catalogLine) 0;
  package = removeAttrs (
    upstream
    // {
      dependencies = lib.mapAttrs (
        _: version: if version == "catalog:" then catalogVersion else version
      ) (upstream.dependencies or { });
    }
  ) [ "devDependencies" ];
  # package-lock.json 是按上游 packages/cli/package.json 手工生成的 npm lock：
  #   1. 把 dependencies 里的 "catalog:" 换成 pnpm-workspace.yaml 中的版本；
  #   2. 去掉 devDependencies；
  #   3. 以旧 lock 为基准运行 npm install --package-lock-only。
  # 更新 astryx 输入后如果上游改了依赖，需要重新生成；否则 importNpmLock
  # 会报类似 attribute '"node_modules/...":' missing。
  packageLock = lib.importJSON ./package-lock.json;
  modules = importNpmLock.buildNodeModules {
    inherit package packageLock nodejs;
    derivationArgs = {
      # postinstall 要读仓库里的脚本；依赖安装本身不执行这些脚本。
      # importNpmLock 现在默认启用 structuredAttrs，sanitized package.json
      # 和 package-lock.json 以 $package / $packageLock 字符串提供，
      # 不再有 $packagePath / $packageLockPath。
      postPatch = ''
        cp -a ${cliRoot}/. .
        chmod -R u+w .
        printf "%s" "$package" > package.json
        printf "%s" "$packageLock" > package-lock.json
      '';
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "astryx";
  version = package.version;

  src = cliRoot;

  nativeBuildInputs = [
    makeBinaryWrapper
    nodejs
  ];

  installPhase = ''
    runHook preInstall

    dest="$out/lib/node_modules/@astryxdesign/cli"
    mkdir -p "$dest" "$out/bin"
    cp -a . "$dest"
    chmod -R u+w "$dest"
    cp ${builtins.toFile "astryx-package.json" (builtins.toJSON package)} "$dest/package.json"
    ln -s ${modules}/node_modules "$dest/node_modules"

    makeWrapper ${nodejs}/bin/node "$out/bin/astryx" \
      --add-flags "$dest/clients/cli/bin/astryx.mjs"
    ln -s astryx "$out/bin/cli"

    runHook postInstall
  '';

  meta = {
    description = "Astryx command-line interface";
    homepage = "https://github.com/meta/astryx";
    license = lib.licenses.mit;
    mainProgram = "astryx";
    inherit (finalAttrs) version;
  };
})
