# T3 Code 桌面程序。上游只发布 AppImage，用 appimage.nix 打包。
{ inputs, pkgs, ... }:

let
  agentApp = import ./appimage.nix { inherit pkgs; };
in
{
  home.packages = [
    (agentApp {
      pname = "t3code";
      version = "0.1.9";
      src = inputs.t3code;
      desktopName = "T3 Code";
      wmClass = "t3code";
      mimeTypes = [ "x-scheme-handler/t3code" ];
    })
  ];
}
