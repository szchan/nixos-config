# Grok Bot。nixpkgs 没有它，包由 grok-bot flake 的 overlay 提供。
{ pkgs, ... }:

{
  home.packages = [
    pkgs.grok-bot
  ];
}
