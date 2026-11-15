# vercel-labs/skills 提供的 find-skills，只放在通用 .agents/skills 目录，
# 供 skills CLI 发现和安装其它 skill。
{ inputs, lib, ... }:

let
  inherit (import ../lib.nix { inherit lib; }) link roots;
in
{
  home.file = link {
    skills = {
      find-skills = inputs.vercel-skills + "/skills/find-skills";
    };
    roots = roots.universal;
  };
}
