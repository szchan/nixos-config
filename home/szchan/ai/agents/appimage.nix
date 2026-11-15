# AppImage 打包辅助函数，由 t3code.nix 和 deepseek-harness-desktop.nix 使用。
# 它不是模块，所以不在 default.nix 里导入。
{ pkgs }:
{
  pname,
  version,
  src,
  desktopName,
  wmClass,
  mimeTypes ? [ ],
}:
let
  desktop = pkgs.makeDesktopItem {
    name = pname;
    inherit desktopName mimeTypes;
    exec = "${pname} %U";
    startupWMClass = wmClass;
    categories = [ "Development" ];
    terminal = false;
  };
in
pkgs.appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    cp ${desktop}/share/applications/*.desktop "$out/share/applications/"
  '';
  meta.mainProgram = pname;
}
