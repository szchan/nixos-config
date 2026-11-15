# Astryx 提供 CLI 和它生成的 SKILL.md，两者都从上游构建。
{ inputs, lib, pkgs, ... }:

let
  inherit (import ../lib.nix { inherit lib; }) link roots;

  astryx = pkgs.callPackage ./package.nix {
    repo = inputs.astryx;
  };

  skill = pkgs.runCommand "astryx-skill" { } ''
    mkdir -p "$out"
    ${pkgs.nodejs}/bin/node --input-type=module -e '
      import { writeFileSync } from "node:fs";
      import { renderComputerAgentText } from "${astryx}/lib/node_modules/@astryxdesign/cli/foundation/agent-docs/computer-agent-text.mjs";
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
