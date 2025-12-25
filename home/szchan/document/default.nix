{ config, pkgs, ... }:

{
    imports = [
        ./yazi.nix
        ./evince.nix
        ./drawio.nix
        ./foliate.nix
        ./folo.nix
        ./logseq.nix
        ./marktext.nix
        ./onlyoffice.nix
    ];
}