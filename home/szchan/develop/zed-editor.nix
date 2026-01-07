{ pkgs, ... }:

# Zed无法正常在我的电脑上使用vulkan导致冻结，我给它加了参数，以WAYLAND_DISPLAY "" zeditor启动以fallback到x11(使用Xwayland)
let
  zed-wrapped = pkgs.symlinkJoin {
    name = "zed-editor-wrapped";
    paths = [ pkgs.zed-editor ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/zeditor \
        --set WAYLAND_DISPLAY ""
    '';
  };
in
{
  programs.zed-editor = {
    enable = true;
    package = zed-wrapped;
    extensions = [
      "nix"
      "catppuccin"
      "catppuccin-icons"
    ];
    themes = {
      mode = "system";
      light = "Catppuccin Latte";
      dark = "Catppuccin Mocha";
    };
  };

  home.packages = with pkgs; [
    nil
  ];
}
