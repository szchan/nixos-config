{ config, pkgs, inputs, ... }:

{
  programs.zed-editor = {
    enable = true;
    # package = inputs.zed.packages.${pkgs.stdenv.hostPlatform.system}.default;
    package = pkgs.zed-editor-fhs;
    extensions = [
      "nix"
    ];
    themes = {

    };
  };
}