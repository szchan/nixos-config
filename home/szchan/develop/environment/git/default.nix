{ config, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./gh.nix
  ];
}