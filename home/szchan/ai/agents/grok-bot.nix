# Grok Bot。nixpkgs 没有它，直接用 grok-bot flake 提供的包。
{ inputs, pkgs, ... }:

{
  home.packages = [
    inputs.grok-bot.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
