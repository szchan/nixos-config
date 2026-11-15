# 1Password 的 MCP 服务，只被 Codex 使用。
# 写进可修改的 config.toml，其余配置留给程序自己更新。
{ lib, ... }:

{
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
}
