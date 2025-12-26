{ config, pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.vivaldi;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1Password
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "fjkmabmdepjfammlpliljpnbhleegehm"; } # WebRTC Control
      { id = "bdiifdefkgmcblbcghdlonllpjhhjgof"; } # KISS Translator
      { id = "kefjpfngnndepjbopdmoebkipbgkggaa"; } # RSSHub Radar
    ];
  };
}