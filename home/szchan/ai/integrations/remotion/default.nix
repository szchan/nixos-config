# remotion-dev/skills 提供的一组 Remotion skill。每个子目录一个 skill。
{ inputs, lib, ... }:

let
  inherit (import ../lib.nix { inherit lib; }) link roots;

  skillNames =
    root:
    lib.attrNames (
      lib.filterAttrs (
        name: type:
        type == "directory" && builtins.pathExists (root + "/${name}/SKILL.md")
      ) (builtins.readDir root)
    );

  root = inputs.remotion-skills + "/skills";
  skills = lib.genAttrs (skillNames root) (name: root + "/${name}");
in
{
  home.file = link {
    inherit skills;
    roots = roots.shared;
  };
}
