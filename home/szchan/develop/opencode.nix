{ pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    enableMcpIntegration = true;
    settings = {
      theme = "system";
    };
  };
}
