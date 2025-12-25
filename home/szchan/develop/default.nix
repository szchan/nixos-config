{ config, pkgs, ... }:

{
    imports = [
        ./nom.nix
        ./hugo.nix
        ./zed-editor.nix
        ./vscode.nix
    ];
}