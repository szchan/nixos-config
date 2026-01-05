{ config, pkgs, inputs, ... }:

{
  programs.zed-editor = {
    enable = true;
    package = inputs.zed.packages.${pkgs.stdenv.hostPlatform.system}.default;
    extensions = [
      "nix"
    ];
    themes = {

    };
  };
}