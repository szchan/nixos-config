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
  package = removeAttrs (upstream // {
    dependencies = lib.mapAttrs (
      _: version: if version == "catalog:" then catalogVersion else version
    ) (upstream.dependencies or { });
  }) [ "devDependencies" ];
  packageLock = lib.importJSON ./package-lock.json;
  modules = importNpmLock.buildNodeModules {
    inherit package packageLock nodejs;
    derivationArgs = {
      # postinstall 要读仓库里的脚本；依赖安装本身不执行这些脚本。
      postPatch = ''
        cp -a ${cliRoot}/. .
        chmod -R u+w .
        cp --no-preserve=mode "$packagePath" package.json
        cp --no-preserve=mode "$packageLockPath" package-lock.json
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
