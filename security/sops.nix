{config, pkgs, }:

{
  environment.systemPackages = [
    pkgs.sops
  ];
}