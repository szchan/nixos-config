{ inputs, pkgs, ... }:

let
  settings = {
    onboarding = false;
    ui = {
      show_agent_labels_on_pane_borders = true;
      status_indicators = "dots";
      toast.delivery = "terminal";
    };
  };
in
{
  # 官方 flake 提供软件包。当前 home-manager 修订没有 programs.herdr，
  # 配置仍按该模块的方式用 TOML 生成。
  home.packages = [ inputs.herdr.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  xdg.configFile."herdr/config.toml".source =
    (pkgs.formats.toml { }).generate "herdr-config.toml" settings;
}
