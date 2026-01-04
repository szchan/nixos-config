{config, pkgs, ...}:

{
  imports = [
    ./cursorTheme.nix
    ./iconTheme.nix
    ./niri-dotfiles.nix
  ];
}