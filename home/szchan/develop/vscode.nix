{ config, pkgs, vscode-extensions, ... }:

{
    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        mutableExtensionsDir = false;  # Pure Nix approach

        profiles.default = {
            extensions = 
            # fetch from open-vsx
            (with vscode-extensions.open-vsx; [
                # vim emulation
                vscodevim.vim

                # Cline AI
                saoudrizwan.claude-dev
                
                # Theming and appearance
                catppuccin.catppuccin-vsc
                pkief.material-icon-theme
                prettier.prettier-vscode
                oderwat.indent-rainbow
                
                # Web Development
                ecmel.vscode-html-css
                yandeu.five-server
                vue.volar
                bruno-api-client.bruno
                
                # Xml and Yaml
                redhat.vscode-xml
                redhat.vscode-yaml
                
                # Nix
                jnoortheen.nix-ide
                
                # Rust
                rust-lang.rust-analyzer

                # Diagrams
                pomdtr.excalidraw-editor
                bpruitt-goddard.mermaid-markdown-syntax-highlighting

            ])
            ++
            # fetch from vscode-marketplace
            (with vscode-extensions.vscode-marketplace; [
                # GitHub Integration
                github.remotehub
                github.vscode-pull-request-github
                github.vscode-github-actions
                
                # LLM Dev Tools
                poml-team.poml

                # Containers
                ms-azuretools.vscode-containers
                ms-vscode-remote.remote-containers

                # Remote Development
                ms-vscode-remote.remote-ssh
                ms-vscode-remote.remote-ssh-edit
                ms-vscode.remote-explorer
                ms-vscode.remote-server

                # Python
                ms-python.python
                ms-python.vscode-pylance
                ms-python.debugpy
                ms-python.vscode-python-envs

                # Hex Editor
                ms-vscode.hexeditor

                # AI Assistance
                github.copilot-chat

                # markdown
                edwinkofler.vscode-hyperupcall-pack-markdown
                bierner.markdown-preview-github-styles
                bierner.markdown-mermaid
                davidanson.vscode-markdownlint
                yzhang.markdown-all-in-one
                unifiedjs.vscode-mdx
                bierner.markdown-shiki
                bierner.markdown-emoji
                bierner.markdown-checkbox
                bierner.emojisense
                bierner.markdown-footnotes

                # Diagrams
                hediet.vscode-drawio

                # LLDB
                # vadimcn.vscode-lldb

            ]);

            # User Settings
            userSettings = {
                
            };
        };
    };
}