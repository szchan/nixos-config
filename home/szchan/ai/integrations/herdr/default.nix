# herdrdev/herdr 自带的 herdr skill。
{ inputs, lib, ... }:

let
  inherit (import ../lib.nix { inherit lib; }) link roots;
in
{
  home.file = link {
    skills = {
      herdr = inputs.herdr.outPath + "/skills/herdr";
    };
    roots = roots.shared;
  };
}
