{ config, pkgs, ... }:

{
	programs.thunar = {
		enable = true;
		plugins = with pkgs; [
			thunar-archive-plugin
			thunar-volman
			thunar-vcs-plugin
		];
	};
}