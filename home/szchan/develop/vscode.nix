{ config, pkgs, vscode-extensions, ... }:

{
    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        mutableExtensionsDir = false;

        profiles.default = {
        extensions = with vscode-extensions; [
            # vim emulation
            vscodevim.vim

            # Cline AI
            saoudrizwan.claude-dev

            # Theming and appearance
            catppuccin.catppuccin-vsc
            pkief.material-icon-theme
            esbenp.prettier-vscode
            oderwat.indent-rainbow

            # Web Development
            ecmel.vscode-html-css
            ritwickdey.liveserver
            vue.volar

            # Remote Development / Containers (Microsoft 官方)
            ms-vscode-remote.remote-ssh
            ms-vscode-remote.remote-ssh-edit
            ms-vscode.remote-explorer
            ms-azuretools.vscode-containers  # Dev Containers
            ms-vscode-remote.remote-containers

            # Python
            ms-python.python
            ms-python.vscode-pylance
            ms-python.debugpy

            # Xml and Yaml
            redhat.vscode-xml
            redhat.vscode-yaml

            # Nix
            jnoortheen.nix-ide

            # Rust
            rust-lang.rust-analyzer

            # GitHub Integration
            github.vscode-pull-request-github
            github.vscode-github-actions
            github.copilot-chat  # Copilot Chat

            # LLM Dev Tools

            # Hex Editor
            ms-vscode.hexeditor

            # Markdown
            bierner.markdown-preview-github-styles
            bierner.markdown-mermaid
            davidanson.vscode-markdownlint
            yzhang.markdown-all-in-one
            unifiedjs.vscode-mdx
            bierner.markdown-emoji
            bierner.markdown-checkbox
            bierner.emojisense
            bierner.markdown-footnotes

            # Diagrams
            pomdtr.excalidraw-editor
            bpruitt-goddard.mermaid-markdown-syntax-highlighting
            hediet.vscode-drawio

            # LLDB
            # vadimcn.vscode-lldb
        ];

        userSettings = {
            
        };
        };
    };
}