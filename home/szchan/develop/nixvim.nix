{ config, pkgs, inputs, ... }:

{
  # 导入 nixvim 的 home-manager 模块
  imports = [ inputs.nixvim.homeModules.nixvim ];

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
      vim.opt.number = true                     -- 在当前行左侧显示绝对行号
      vim.opt.relativenumber = true             -- 显示相对行号, 便于计算行号差进行跳转
      vim.opt.signcolumn = "yes"                -- 始终显示符号列，避免文本抖动
      vim.opt.cursorline = true                 -- 高亮显示当前行

      -- 缩进
      vim.opt.expandtab = true                  -- 按 Tab 键时插入空格，而不是真正的 \t 字符
      vim.opt.shiftwidth = 2                    -- 使用 >>、<<、== 等命令缩进时的宽度为 2 个空格
      vim.opt.tabstop = 2                       -- 一个 Tab 字符显示为 2 个空格宽
      vim.opt.smartindent = true                -- 根据代码结构自动缩进

      -- 搜索
      vim.opt.ignorecase = true                 -- 搜索时忽略大小写
      vim.opt.smartcase = true                  -- 如果搜索模式包含大写字母，则区分大小写
      vim.opt.hlsearch = true                   -- 高亮显示搜索结果

      -- 其他常用
      vim.opt.termguicolors = true              -- 启用终端的真彩色支持
      vim.opt.mouse = "a"                       -- 启用鼠标支持，所有模式下均可使用鼠标
      -- vim.opt.clipboard = "unnamedplus"      -- 使用系统剪贴板（已通过 clipboard.providers.wl-copy 启用，这里注释掉）
      vim.opt.updatetime = 300                  -- 减少等待时间，提高响应速度
      vim.opt.timeoutlen = 500                  -- 键盘映射等待时间
      vim.opt.scrolloff = 8                     -- 光标上下保留 8 行

      -- Leader 键设为空格
      vim.g.mapleader = " "                     -- 把全局 leader 键设为空格键
      vim.g.maplocalleader = " "                -- 把局部(buffer 级)leader 键也设为空格键
    '';

    # 颜色主题
    colorschemes.tokyonight = {
      enable = true;
      style = "storm";  # storm / night / moon / day
      transparent = false;
      terminalColors = true;
    };

    # 剪贴板集成
    clipboard.providers.wl-copy = {
      enable = true;
    };

    # 常用插件（全开现代 Neovim 常用套件）
    plugins = {
      # 状态栏
      lualine = {
        enable = true;
        theme = "tokyonight";
      };

      web-devicons = {
        enable = true;
      };

      # 文件浏览器
      neo-tree = {
        enable = true;
        settings = {
          close_if_last_window' = true;
        };
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
    # nodePackages.pyright
    
    # TypeScript / JavaScript
    gopls
    
    # C/C++
    clang-tools
  ];
}