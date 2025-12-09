{ inputs, ... }: {
  imports = [ ./disko-config.nix ];
  _module.args.disks = [ "/dev/vda" ];
}
