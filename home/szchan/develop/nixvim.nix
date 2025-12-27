{ config, pkgs, inputs, ... }:

{
  # 导入 nixvim 的 home-manager 模块
  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;

    # nvim 设置为默认编辑器
    defaultEditor = true;

    # 绑定vim/vi/vimdiff命令
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # 全局 vim 选项, Lua 代码
    extraConfigLua = ''
      -- 基本外观和行为
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.signcolumn = "yes"
      vim.opt.cursorline = true

      -- 缩进
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 2
      vim.opt.tabstop = 2
      vim.opt.smartindent = true

      -- 搜索
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = true

      -- 其他常用
      vim.opt.termguicolors = true
      vim.opt.mouse = "a"
      vim.opt.clipboard = "unnamedplus"
      vim.opt.updatetime = 300
      vim.opt.timeoutlen = 500
      vim.opt.scrolloff = 8

      -- Leader 键设为空格（大多数现代配置都这么做）
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
    '';

    # 颜色主题
    colorschemes.tokyonight = {
      enable = true;
      style = "storm";  # storm / night / moon / day
      transparent = false;
      terminalColors = true;
    };

    # 常用插件（全开现代 Neovim 常用套件）
    plugins = {
      # 状态栏
      lualine = {
        enable = true;
        theme = "tokyonight";
      };

      # 文件浏览器
      neo-tree = {
        enable = true;
        closeIfLastWindow = true;
      };

      # 模糊查找
      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
      };

      # 语法高亮
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };

      # LSP 支持
      lsp = {
        enable = true;
        servers = {
          nil_ls.enable = false;        # Nix
          nixd.enable = true;         # 使用nixd 关 nil_ls
          lua_ls.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;      # 如果用 rustup 管理 cargo，就关掉
            installRustc = false;
          };
          pyright.enable = true;
          ts_ls.enable = true;
          bashls.enable = true;
          gopls.enable = true;
          clangd.enable = true;
          html.enable = true;
          cssls.enable = true;
        };
      };

      # 自动补全
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "buffer"; }
          { name = "path"; }
        ];
      };

      # 代码片段
      luasnip.enable = true;

      # 快速跳转/显示键位提示
      which-key.enable = true;

      # 注释快捷键 gc / gcc
      comment.enable = true;

      # 自动括号等
      nvim-autopairs.enable = true;
    };

    # 常用快捷键（强烈推荐）
    keymaps = [
      # Leader 快捷键示例
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find Files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Live Grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options.desc = "Buffers";
      }
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Toggle NeoTree";
      }
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<cr>";
        options.desc = "Save";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<cr>";
        options.desc = "Quit";
      }

      # 窗口快速切换
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.silent = true; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.silent = true; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.silent = true; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.silent = true; }
    ];
  };

  # nixvim 依赖的外部工具
  home.packages = with pkgs; [
    # Telescope
    ripgrep
    fd

    # Nix 相关
    nixd               # 或 nixd，如果你用了 nixd
    nixfmt-rfc-style  # nix 格式化

    # Lua
    stylua

    # rust-analyzer
    rust-analyzer     

    # Python 
    nodePackages.pyright
    
    # TypeScript / JavaScript
    gopls
    
    # C/C++
    clang-tools
  ];
}