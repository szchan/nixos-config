{config, pkgs, lib, ...}: 

{
  imports = [
    ./custom-rime.nix  # 导入自定义 RIME 模块
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-configtool # GUI for fcitx5
      fcitx5-gtk # gtk im module

      # Chinese
      fcitx5-rime # for flypy chinese input method

    ];
  };

  # 启用自定义 RIME 模块
  customRime.enable = true;
}