{ config, pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        zsh
        vim
        neovim
        wget
        curl
        aria2
        tmux
        htop
        btop
        fastfetch
        git
        tree
        bat
        fd
        ripgrep
        eza
        fzf
        jq
        lsd
        ncdu
        hexyl
        tldr
        procs
        zoxide
        direnv
        lazydocker
        lazygit
        gh
        starship
        lm_sensors # for `sensors` command
        ethtool
        pciutils # lspci
        usbutils # lsusb
    ];
}