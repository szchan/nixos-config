{config, pkgs, ...}:

{
  environment.systemPackages = [
    pkgs.age
  ];
}