{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      package = pkgs.nerd-fonts.jetbrains-mono;
      size = 12;
    };
    settings = {
      remember_window_size = false;
      initial_window_width = 950;
      initial_window_height = 500;
      cursor_blink_interval = 0.5;
      cursor_stop_blinking_after = 1;
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;
      enable_audio_bell = false;
      window_padding_width = 10;
      hide_window_decorations = true;
      background_opacity = 0.7;
      dynamic_background_opacity = true;
      confirm_os_window_close = 0;
    };
  };
}