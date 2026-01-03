{ config, lib, pkgs, ... }:
let
  # Define the command to start Niri, using niri-session is recommended
  niriSessionCommand = "${pkgs.niri}/bin/niri-session";
in
{
  # Enable Niri program (installs binaries and sets up portals/keyring services)
  programs.niri.enable = true;

  # Enable the greetd service
  services.greetd = {
    enable = true;
    settings = {
      # Configure the default session for automatic login (optional, but common)
      # This skips the greeter interface and boots straight into Niri for 'myuser'
      initial_session = {
        command = niriSessionCommand;
        user = "szchan"; # Replace with your actual username
      };
      # If you want a login prompt, use 'default_session' instead and a greeter
      # (e.g., tuigreet or gtkgreet).
    };
  };