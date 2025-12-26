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
                esbenp.prettier-vscode
                oderwat.indent-rainbow
                # Dev Containers
                ms-azuretools.vscode-containers
                # Git and GitHub
                mhutchie.git-graph
                github.vscode-github-actions
                github.vscode-pull-request-github
                # Web Development
                ecmel.vscode-html-css
                yandeu.five-server
                vue.volar
                bruno-api-client.bruno
                # Remote Development
                jeanp413.open-remote-ssh
                # Python
                ms-python.python
                ms-python.debugpy
                ms-python.vscode-python-envs
                # Xml and Yaml
                redhat.vscode-xml
                redhat.vscode-yaml
                # Nix
                jnoortheen.nix-ide
                # Rust
                rust-lang.rust-analyzer
                # Testing and Debugging
                # vadimcn.vscode-lldb
                # Markdown
                edwinkofler.vscode-hyperupcall-pack-markdown
            ])
            ++
            # fetch from vscode-marketplace
            (with vscode-extensions.vscode-marketplace; [
                # GitHub Integration
                github.remotehub
                github.vscode-pull-request-github
                # LLM Dev Tools
                poml-team.poml
            ]);

            # User Settings
            userSettings = {
                
            };
        };
    };
}