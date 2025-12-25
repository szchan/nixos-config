{ config, pkgs, vscode-extensions, ... }:

{
    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        mutableExtensionsDir = false;  # Pure Nix approach

        extensions = 
        # fetch from open-vsx
        (with vscode-extensions.open-vsx; [
            # jnoortheen.nix-ide
            # rust-lang.rust-analyzer
            # vadimcn.vscode-lldb
        ])
        ++
        # fetch from vscode-marketplace
        (with vscode-extensions.vscode-marketplace; [
            
        ]);

        # User Settings
        userSettings = {
            
        };
    };
}