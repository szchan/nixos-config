{
  description = "gateway flake";

  # 注意：flake 的 inputs 必须是字面量 attrset。
  # Nix 不会求值这里的 import、函数或条件表达式（会报 expected a set but got a thunk），
  # 所以 input 声明无法拆到别的文件，也无法按主机区分。
  # 能拆的是“怎么使用这些 input”：模块、overlay 和包覆盖都在各自目录里，
  # 通过 specialArgs 拿到 inputs，见 flake/mkSystem.nix。
  inputs = {
    # ---- 核心 ----

    # NixOS 官方软件源，这里使用 nixos-unstable 分支。
    # 原来的 nixos-25.11 写法保留在注释里。
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # disko 模块
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # home-manager 模块
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpak 模块
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-private
    # nixos-private = {
    #   url = "git+ssh://git@github.com/szchan/nixos-private.git";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # ---- 开发 / 编辑 ----

    # nixvim
    # 不跟随 nixpkgs：nixvim 按上游自己的 flake.lock 锁定 nixpkgs-unstable。
    # 注意 home-manager 开了 useGlobalPkgs，实际构建仍复用系统 pkgs，
    # 因此 programs.nixvim.nixpkgs.source 在 nixvim.nix 里显式指向系统 nixpkgs。
    nixvim = {
      url = "github:nix-community/nixvim";
    };

    # ---- 桌面应用 ----

    # OpenAI 官方 Linux 桌面程序。nixpkgs 里的 chatgpt 只有 Darwin。
    chatgpt-desktop-app = {
      url = "github:poeck/chatgpt-desktop-app-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Grok Bot 官方 Linux 包不在 nixpkgs。这个 flake 只提供打包。
    grok-bot = {
      url = "github:ponelat/grok-bot-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 上游发布的安装包。地址里的版本是锁，文件哈希在 flake.lock。
    t3code = {
      url = "https://github.com/pingdotgg/t3code/releases/download/v0.1.9/T3-Code-0.1.9-x86_64.AppImage";
      flake = false;
    };
    deepseek-harness-desktop = {
      url = "https://github.com/ffyfox/dsh-desktop-linux/releases/download/v0.2.2rc2/deepseek-harness-0.2.2-rc.2-linux-x86_64-unsigned.AppImage";
      flake = false;
    };

    # ---- AI 工具 ----

    # herdr 官方打包。它需要比本仓库更新的 Zig，所以使用它自己的 nixpkgs。
    # 当前锁定的 home-manager 还没有 programs.herdr。
    herdr.url = "github:herdrdev/herdr";

    # oh-my-pi 官方 flake，带 programs.omp。工具链跟随它自己的 nixpkgs。
    omp.url = "github:can1357/oh-my-pi";

    # 当前锁定的 nixpkgs 还没有 pi-coding-agent。
    nixpkgs-pi.url = "github:NixOS/nixpkgs/nixos-unstable";

    # ---- skills ----

    # 这些输入跟随上游默认分支。修订记录在 flake.lock，用 nix flake update 更新。
    remotion-skills = {
      url = "github:remotion-dev/skills";
      flake = false;
    };
    vercel-skills = {
      url = "github:vercel-labs/skills";
      flake = false;
    };
    graphify = {
      url = "github:Graphify-Labs/graphify";
      flake = false;
    };
    obsidian-skills = {
      url = "github:kepano/obsidian-skills";
      flake = false;
    };
    astryx = {
      url = "github:meta/astryx";
      flake = false;
    };

    # ---- 停用，需要时取消注释 ----

    # Zed-editor
    # zed = {
    #   url = "github:zed-industries/zed";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # rime-ice
    # rime-ice = {
    #   url = "github:iDvel/rime-ice/nightly";
    #   flake = false;
    # };

    # Dank-Material-Shell
    # dms = {
    #   url = "github:AvengeMedia/DankMaterialShell/stable";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # niri-flake
    # niri = {
    #   url = "github:sodiboo/niri-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  # flake 输出只做入口：主机注册在 flake/outputs.nix，系统组装在 flake/mkSystem.nix。
  outputs = inputs: import ./flake/outputs.nix inputs;
}
