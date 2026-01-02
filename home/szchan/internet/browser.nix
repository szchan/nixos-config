{ config, pkgs, ... }:

{
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
    extensions = [
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1Password
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "fjkmabmdepjfammlpliljpnbhleegehm"; } # WebRTC Control
      { id = "bdiifdefkgmcblbcghdlonllpjhhjgof"; } # KISS Translator
      { id = "kefjpfngnndepjbopdmoebkipbgkggaa"; } # RSSHub Radar
      { id = "jfgfiigpkhlkbnfnbobbkinehhfdhndo"; } # Page Assistss
    ];
  };

  home.packages = with pkgs; [
    vivaldi
  ];
}
