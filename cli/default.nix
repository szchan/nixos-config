{ config, pkgs, ... }:

{
  imports = [ 
    ./packages.nix
    ./zsh.nix
  ];
}