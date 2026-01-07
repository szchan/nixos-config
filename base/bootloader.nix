{ lib, ... }:

{
  boot.loader.systemd-boot = {
    enable = true;

    # Limit the number of boot entries to keep
    # configurationLimit = lib.mkDefault 10;

    # pick the highest resolution for systemd-boot's console.
    consoleMode = lib.mkDefault "max";

  };

  # wait for x seconds to select the boot entry.
  boot.loader.timeout = lib.mkDefault 8;

  boot.loader.efi.canTouchEfiVariables = true;
}
