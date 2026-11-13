{ ... }:

{
  # herdr 目前不在 nixpkgs。配置先放好，软件另行安装。
  xdg.configFile."herdr/config.toml".text = ''
    # Herdr uses its built-in official defaults for all omitted settings.
    # Retain completed onboarding and existing local preferences.
    onboarding = false

    [ui]
    show_agent_labels_on_pane_borders = true

    status_indicators = "dots"
    [ui.toast]
    delivery = "terminal"
  '';
}
