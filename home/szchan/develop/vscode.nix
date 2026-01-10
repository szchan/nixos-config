{
  pkgs,
  vscode-extensions,
  ...
}:

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
        # saoudrizwan.claude-dev

        # Theming and appearance
        catppuccin.catppuccin-vsc
        catppuccin.catppuccin-vsc-icons
        esbenp.prettier-vscode
        oderwat.indent-rainbow

        # Web Development
        ecmel.vscode-html-css
        ritwickdey.liveserver
        vue.volar

        # Test
        # bruno-api-client.bruno

        # Remote Development / Containers (Microsoft 官方)
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode.remote-explorer
        ms-azuretools.vscode-containers # Dev Containers
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
        # github.vscode-pull-request-github
        github.vscode-github-actions
        # github.copilot-chat  # Copilot Chat

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
        hediet.vscode-drawio

        # LLDB
        # vadimcn.vscode-lldb
      ];

      userSettings = {
        # 自动保存
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000; # 延迟多少秒后保存，单位毫秒

        # Git
        "git.autofetch" = true;
        "git.confirmSync" = false;

        # 设置Color Theme和Icon Theme 为Catppuccin Mocha
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme" = "catppuccin-mocha";
        "editor.semanticHighlighting.enabled" = true;
        "terminal.integrated.minimumContrastRatio" = 1;
        "window.titleBarStyle" = "custom";
        "gopls" = {
          "ui.semanticTokens" = true;
        };

        # 编辑器主字体（代码区）
        "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace'";
        "editor.fontSize" = 14; # 根据你的显示器调整，13-15 常见
        "editor.fontLigatures" = true; # 启用连字（=> => => 变成箭头等）
        "editor.lineHeight" = 1.8; # 行距

        # 终端字体
        "terminal.integrated.fontFamily" = "'JetBrainsMono Nerd Font'";
        "terminal.integrated.fontSize" = 14;
        "terminal.integrated.lineHeight" = 1.2;

        # 左侧侧边栏（包括 Explorer、Search 等）的字体和字号
        "workbench.sideBar.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace'";
        "workbench.sideBar.fontSize" = 13; # 推荐 13~14，清晰不占空间

        # Tab 标题的字体和字号（打开文件后的标签）
        "workbench.editor.tabFontFamily" = "'JetBrainsMono Nerd Font', 'monospace'";
        "workbench.editor.tabFontSize" = 13; # 推荐 13，比正文略小，层次感好
        "workbench.editor.tabFontWeight" = "600"; # 活动 Tab（当前打开的文件）加粗，更突出

        # Activity Bar
        "workbench.activityBar.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace'";
        "workbench.activityBar.fontSize" = 13;

        # Nix-IDE
        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "nixd"; # 直接使用 nixd 可执行文件（假设它在你的 PATH 中）
        "nix.serverSettings" = {
          nixd = {
            formatting = {
              command = [ "nixfmt" ]; # 使用 nixfmt 格式化（LSP 会优先使用这个）
            };
            options = {
              # 如果你使用 flake 配置 NixOS，可启用 NixOS 选项补全
              # 将 <name> 替换为你的 hostname 或 configuration name
              nixos = {
                expr = "(builtins.getFlake \"/home/szchan/Projects/nixos-config\").nixosConfigurations.szchanNixOSStation.options";
              };
              # 如果你使用 Home Manager standalone 或 flake，需要启用 HM 选项补全
              # home-manager = {
              #   expr = "(builtins.getFlake \"/home/szchan/Projects/nixos-config\").homeConfigurations.szchanNixOSStation.options";
              # };
            };
          };
        };
      };
    };
  };

  home.packages = with pkgs; [
    nixd
    nixfmt
  ];
}
