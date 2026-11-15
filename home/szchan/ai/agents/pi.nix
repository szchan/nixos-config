# pi-coding-agent。当前锁定的 nixpkgs 还没有它，用 nixpkgs-pi 里的版本。
{ inputs, pkgs, ... }:

let
  piPkgs = inputs.nixpkgs-pi.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = [
    piPkgs.pi-coding-agent
  ];
}
