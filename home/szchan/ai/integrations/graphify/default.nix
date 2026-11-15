# Graphify 的 Python CLI，以及它给 Claude Code 用的 skill。
# skill 里的 .graphify_version 要和 CLI 版本一致，所以版本号只从上游读一次。
{ inputs, lib, pkgs, ... }:

let
  inherit (import ../lib.nix { inherit lib; }) link roots;

  versionLine = lib.findFirst (lib.hasPrefix "version = ") "" (
    lib.splitString "\n" (builtins.readFile (inputs.graphify + "/pyproject.toml"))
  );
  version = builtins.elemAt (builtins.match "version = \"([^\"]+)\"" versionLine) 0;

  piPkgs = inputs.nixpkgs-pi.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  cli = piPkgs.graphify.overridePythonAttrs (old: {
    inherit version;
    src = inputs.graphify;
    dependencies = old.dependencies ++ [ piPkgs.python3Packages.pyyaml ];
  });

  skill = pkgs.runCommand "graphify-claude-skill" { } ''
    mkdir -p "$out/references"
    cp ${inputs.graphify}/graphify/skill.md "$out/SKILL.md"
    cp -R ${inputs.graphify}/graphify/skills/claude/references/. "$out/references/"
    printf '%s' ${lib.escapeShellArg version} > "$out/.graphify_version"
  '';
in
{
  home.packages = [
    cli
  ];

  home.file = link {
    skills = {
      graphify = skill;
    };
    roots = roots.claude;
  };
}
