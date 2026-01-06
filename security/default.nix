{ config, pkgs, ... }:

{
  imports = [
    ./firewall.nix
    ./suid.nix
    ./ssh.nix
    ./age.nix
    ./sops.nix
    ./polkit.nix
    ./trustedCache.nix
  ];
}