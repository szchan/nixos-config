{ inputs, lib, pkgs, ... }:

let
  skillNames = root:
    lib.attrNames (
      lib.filterAttrs (
        name: type:
        type == "directory" && builtins.pathExists (root + "/${name}/SKILL.md")
      ) (builtins.readDir root)
    );

  remotionRoot = inputs.remotion-skills + "/skills";
  remotionSkills = lib.genAttrs (skillNames remotionRoot) (name: remotionRoot + "/${name}");

  herdrSkill = inputs.herdr.outPath + "/skills/herdr";
  obsidianCliSkill = inputs.obsidian-skills + "/plugins/obsidian/skills/obsidian-cli";
  findSkills = inputs.vercel-skills + "/skills/find-skills";

  graphifyVersion =
    let
      line = lib.findFirst (lib.hasPrefix "version = ") "" (
        lib.splitString "\n" (builtins.readFile (inputs.graphify + "/pyproject.toml"))
      );
      matched = builtins.match "version = \"([^\"]+)\"" line;
    in
    builtins.elemAt matched 0;

  graphifySkill = pkgs.runCommand "graphify-claude-skill" { } ''
    mkdir -p "$out/references"
    cp ${inputs.graphify}/graphify/skill.md "$out/SKILL.md"
    cp -R ${inputs.graphify}/graphify/skills/claude/references/. "$out/references/"
    printf '%s' ${lib.escapeShellArg graphifyVersion} > "$out/.graphify_version"
  '';

  piPkgs = inputs.nixpkgs-pi.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  astryx = pkgs.callPackage ./astryx/package.nix {
    repo = inputs.astryx;
  };

  # 以 AppImage 发布的 agent。DeepSeek 官方没有 Linux 安装包，用这台机器已在用的 Electron 构建。
  agentApp = {
    pname,
    version,
    src,
    desktopName,
    wmClass,
    mimeTypes ? [ ],
  }:
  let
    desktop = pkgs.makeDesktopItem {
      name = pname;
      inherit desktopName mimeTypes;
      exec = "${pname} %U";
      startupWMClass = wmClass;
      categories = [ "Development" ];
      terminal = false;
    };
  in
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    extraInstallCommands = ''
      mkdir -p "$out/share/applications"
      cp ${desktop}/share/applications/*.desktop "$out/share/applications/"
    '';
    meta.mainProgram = pname;
  };

  astryxSkill = pkgs.runCommand "astryx-skill" { } ''
    mkdir -p "$out"
    ${pkgs.nodejs}/bin/node --input-type=module -e '
      import { writeFileSync } from "node:fs";
      import { renderComputerAgentText } from "${astryx}/lib/node_modules/@astryxdesign/cli/foundation/agent-docs/computer-agent-text.mjs";
      writeFileSync(process.argv[1], renderComputerAgentText({ command: "astryx" }));
    ' "$out/SKILL.md"
  '';

  sharedSkills = remotionSkills // {
    herdr = herdrSkill;
    obsidian-cli = obsidianCliSkill;
    astryx = astryxSkill;
  };

  linkSkills = root: skills:
    lib.mapAttrs' (name: source: {
      name = "${root}/${name}";
      value = {
        inherit source;
        recursive = true;
      };
    }) skills;
in
{
  imports = [
    inputs.omp.homeManagerModules.default
  ];

  # skills 选项会把字符串路径写成 .md。目录统一用 home.file 链接。
  programs.claude-code.enable = true;

  programs.codex.enable = true;
  programs.omp.enable = true;

  home.packages = [
    piPkgs.pi-coding-agent
    (piPkgs.graphify.overridePythonAttrs (old: {
      version = graphifyVersion;
      src = inputs.graphify;
      dependencies = old.dependencies ++ [ piPkgs.python3Packages.pyyaml ];
    }))
    pkgs.grok-bot
    astryx
    (agentApp {
      pname = "t3code";
      version = "0.1.9";
      src = inputs.t3code;
      desktopName = "T3 Code";
      wmClass = "t3code";
      mimeTypes = [ "x-scheme-handler/t3code" ];
    })
    (agentApp {
      pname = "deepseek-harness-desktop";
      version = "0.2.2-rc.2";
      src = inputs.deepseek-harness-desktop;
      desktopName = "DeepSeek Harness";
      wmClass = "deepseek-ai-dsh-desktop";
      mimeTypes = [ "x-scheme-handler/dsh" ];
    })
  ];

  # Codex 的 MCP 写进可修改的 config.toml。其余配置留给程序自己更新。
  home.activation.codexOnePasswordMcp = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    config_file="$HOME/.codex/config.toml"
    mkdir -p "$(dirname "$config_file")"
    if [ -L "$config_file" ]; then
      rm "$config_file"
    fi
    block=$(cat <<'EOF'
    [mcp_servers.1password]
    command = "1password-mcp"
    EOF
    )
    block=$(printf '%s\n' "$block" | sed 's/^    //')
    if [ ! -e "$config_file" ]; then
      printf '%s\n' "$block" > "$config_file"
    elif [ -f "$config_file" ] && ! grep -q '^\[mcp_servers\.1password\]$' "$config_file"; then
      printf '\n%s\n' "$block" >> "$config_file"
    fi
  '';

  home.file = lib.mkMerge [
    (linkSkills ".agents/skills" (sharedSkills // {
      find-skills = findSkills;
    }))
    (linkSkills ".claude/skills" (sharedSkills // {
      graphify = graphifySkill;
    }))
    (linkSkills ".pi/agent/skills" sharedSkills)
    (linkSkills ".omp/agent/skills" sharedSkills)
  ];
}
