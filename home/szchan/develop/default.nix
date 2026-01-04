{ config, pkgs, ... }:

{
  imports = [
    ./nom.nix
    ./hugo.nix
    ./zed-editor.nix
    ./vscode.nix
    # ./bruno.nix
    ./dbeaver.nix
    ./filezilla.nix
    ./nixvim.nix
    
    ./environment

  ];
}
