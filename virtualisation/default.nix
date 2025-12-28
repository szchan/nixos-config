{config, pkgs, ...}:

{
  imports = [
    ./qemu-kvm.nix
    ./docker.nix
    ./podman.nix
  ];
}