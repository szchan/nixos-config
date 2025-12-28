{ config, pkgs, ... }:

{
    programs.git = {
        enable = true;
        settings = {
            user = {
                name = "szchan";
                email = "mail.szchan@gmail.com";
            };
        };
    };
}