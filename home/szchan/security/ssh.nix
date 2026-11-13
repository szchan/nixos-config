# 不含秘密的部分交给 programs.ssh。主机名和公钥在激活时从 1Password 读取，
# 只写入 Include 文件，避免进入 Nix store，也不覆盖 home-manager 生成的 config。
{ lib, pkgs, ... }:

let
  op = lib.getExe pkgs._1password-cli;
  coreutils = "${pkgs.coreutils}/bin";
  sed = "${pkgs.gnused}/bin/sed";
  vault = "op://ywbln576rlhme3yk4bitbsxheu";
in
{
  programs.ssh = {
    enable = true;
    # 模块自带的 matchBlocks."*" 会改掉转发、压缩和连接复用，并计划在后续版本删除。
    enableDefaultConfig = false;
    includes = [ "~/.ssh/config.d/1password-hosts" ];
    matchBlocks."*" = {
      identityAgent = "~/.1password/agent.sock";
    };
  };

  home.activation.sshFrom1Password = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    umask 077
    ${coreutils}/mkdir -p "$HOME/.ssh/config.d"
    if ! ${op} account get >/dev/null 2>&1; then
      echo "1Password CLI is locked; SSH host entries were left unchanged" >&2
    else
      host1_alias="$(${op} read ${lib.escapeShellArg "${vault}/SSH hosts/host1_alias"})"
      host1_hostname="$(${op} read ${lib.escapeShellArg "${vault}/SSH hosts/host1_hostname"})"
      host1_user="$(${op} read ${lib.escapeShellArg "${vault}/SSH hosts/host1_user"})"
      host2_alias="$(${op} read ${lib.escapeShellArg "${vault}/SSH hosts/host2_alias"})"
      host2_hostname="$(${op} read ${lib.escapeShellArg "${vault}/SSH hosts/host2_hostname"})"
      host2_user="$(${op} read ${lib.escapeShellArg "${vault}/SSH hosts/host2_user"})"
      config_tmp="$(${coreutils}/mktemp)"
      key_tmp="$(${coreutils}/mktemp)"
      cat > "$config_tmp" <<EOF
    Host $host1_alias
        HostName $host1_hostname
        User $host1_user
        IdentityFile ~/.ssh/id_ed25519_1password.pub
        IdentitiesOnly yes

    Host $host2_alias
        HostName $host2_hostname
        User $host2_user
        IdentityFile ~/.ssh/id_ed25519_1password.pub
        IdentitiesOnly yes
    EOF
      ${op} read ${lib.escapeShellArg "${vault}/SSH Key id_ed25519_szchan_shaoze_thinkpad_omarchy/public key"} \
        | ${coreutils}/tr -d '\r' | ${sed} -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' > "$key_tmp"
      echo >> "$key_tmp"
      ${coreutils}/install -m 600 "$config_tmp" "$HOME/.ssh/config.d/1password-hosts"
      ${coreutils}/install -m 600 "$key_tmp" "$HOME/.ssh/id_ed25519_1password.pub"
      ${coreutils}/rm -f "$config_tmp" "$key_tmp"
    fi
  '';
}
