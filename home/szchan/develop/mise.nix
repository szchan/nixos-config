{ pkgs, ... }:

{
  home.packages = [ pkgs.mise ];

  xdg.configFile."mise/config.toml".text = ''
    [tools]
    bun = "latest"
    claude = "latest"
    codex = "latest"
    gh = "latest"
    "github:can1357/oh-my-pi" = "latest"
    go = "latest"
    node = "26.8.2"
    pi = "latest"
    python = "latest"

    [settings.upgrade]
    auto_prune = false
  '';
}
