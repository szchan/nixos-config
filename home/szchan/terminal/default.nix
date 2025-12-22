{config, pkgs, ...}:

{
    imports = [
        ./starship.nix
        ./alacritty.nix
        ./bash.nix
    ];
}