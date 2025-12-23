{config, pkgs, ...}:

{
    imports = [
        ./starship.nix
        ./alacritty.nix
        ./bash.nix
        ./zsh.nix
        ./zoxide.nix
        ./eza.nix
        ./fastfetch.nix
    ];
}