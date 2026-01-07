{ ... }:
{
  imports = [ ./disko-config.nix ];
  _module.args.disks = [ "/dev/nvme0n1" ];
}
