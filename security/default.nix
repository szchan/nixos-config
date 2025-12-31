{ config, pkgs, ... }: {
  imports = [
    ./suid.nix
    ./ssh.nix
    ./age.nix
    ./sops.nix
  ];
}