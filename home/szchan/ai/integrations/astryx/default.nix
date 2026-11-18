# Astryx 提供 CLI 和它生成的 SKILL.md，两者都从上游构建。
#
# SKILL.md 直接从上游源码渲染，不需要 node_modules，所以上游依赖怎么变都不影响
# skill；CLI 的依赖由 deps.nix 从上游 pnpm-lock.yaml 解析，见 package.nix。
{
  inputs,
  lib,
  pkgs,
  ...
}:

let
  inherit (import ../lib.nix { inherit lib; }) link roots;

  repo = inputs.astryx;

  astryx = pkgs.callPackage ./package.nix { inherit repo; };

  skill = pkgs.runCommand "astryx-skill" { } ''
    mkdir -p "$out"
    ${pkgs.nodejs}/bin/node --input-type=module -e '
      import { writeFileSync } from "node:fs";
      import { renderComputerAgentText } from "${repo}/packages/cli/foundation/agent-docs/computer-agent-text.mjs";
      writeFileSync(process.argv[1], renderComputerAgentText({ command: "astryx" }));
    ' "$out/SKILL.md"
  '';
in
{
  home.packages = [
    astryx
  ];

  home.file = link {
    skills = {
      astryx = skill;
    };
    roots = roots.shared;
  };
}
