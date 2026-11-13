{ ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-style = "Regular";
      font-size = 12;
      window-theme = "ghostty";
      window-padding-x = 14;
      window-padding-y = 14;
      confirm-close-surface = false;
      resize-overlay = "never";
      gtk-toolbar-style = "flat";
      cursor-style = "block";
      cursor-style-blink = false;
      shell-integration-features = "no-cursor,ssh-env";
      mouse-scroll-multiplier = 0.95;
      # 规避 libxev epoll 空指针。本机已用 herdr 验证 io_uring 可用。
      async-backend = "io_uring";
      keybind = [
        "shift+insert=paste_from_clipboard"
        "control+insert=copy_to_clipboard"
        "shift+enter=csi:13;2u"
        "alt+shift+enter=csi:13;4u"
        "super+control+shift+alt+arrow_down=resize_split:down,100"
        "super+control+shift+alt+arrow_up=resize_split:up,100"
        "super+control+shift+alt+arrow_left=resize_split:left,100"
        "super+control+shift+alt+arrow_right=resize_split:right,100"
      ];
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "com.mitchellh.ghostty.desktop" ];
  };
}
