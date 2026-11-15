# integration 共用的 skill 链接工具。
{ lib }:
{
  # agent 读取 skill 的目录。新增 agent 时在 shared 里补一条。
  roots = {
    # 所有 agent 都读取的通用 skill。
    shared = [
      ".agents/skills"
      ".claude/skills"
      ".pi/agent/skills"
      ".omp/agent/skills"
    ];

    # 只给通用 .agents/skills 目录用的 skill。
    universal = [
      ".agents/skills"
    ];

    # 只给 Claude Code 用的 skill。
    claude = [
      ".claude/skills"
    ];
  };

  # 把 skill 目录链接到各个 agent 的 skills 目录。
  # 必须用 home.file：agent 的 skills 选项会把字符串路径写成 .md 文件。
  link =
    { skills, roots }:
    lib.mkMerge (
      lib.mapAttrsToList (
        name: source:
        lib.genAttrs (map (root: "${root}/${name}") roots) (_: {
          inherit source;
          recursive = true;
        })
      ) skills
    );
}
