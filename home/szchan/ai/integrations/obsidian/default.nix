# kepano/obsidian-skills 提供的 obsidian-cli skill。
{ inputs, lib, ... }:

let
  inherit (import ../lib.nix { inherit lib; }) link roots;
in
{
  home.file = link {
    skills = {
      obsidian-cli = inputs.obsidian-skills + "/plugins/obsidian/skills/obsidian-cli";
    };
    roots = roots.shared;
  };
}
