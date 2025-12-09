{
  inputs = {
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, nixpkgs, disko, ...}@inputs: {

    nixosConfigurations.mysystem = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs.inputs = inputs;
      modules = [
        disko.nixosModules.disko
        ./disko-config.nix
        {
          _module.args.disks = [ "/dev/vda" ];
        }
      ];
    };
  };
}
