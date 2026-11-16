# 组装一台 NixOS 主机：公共配置 + home-manager + 这台主机自己的模块。
#
# 这里故意不传入预先实例化的 pkgs，让 NixOS 模块系统根据各模块里的
# nixpkgs.config / nixpkgs.overlays 去实例化 pkgs。这样：
#   - overlay 可以写在真正使用它的软件模块里（见 desktop/localsend.nix、
#     base/networking.nix）；
#   - home-manager 的 useGlobalPkgs 会复用同一份 pkgs，overlay 对两边都生效。
{ inputs }:
let
  system = "x86_64-linux";
in
extraModules:
inputs.nixpkgs.lib.nixosSystem {
  inherit system;

  specialArgs = {
    inherit inputs;
  };

  modules = [
    ../configuration.nix
    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "bak";
      home-manager.users.szchan = ../home/szchan/home.nix;
      home-manager.extraSpecialArgs = {
        inherit inputs;
      };
    }
  ]
  ++ extraModules;
}
