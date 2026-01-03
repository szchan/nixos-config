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

	# 补完Thunar的功能集
	services = {
		gvfs.enable = true;
		tumbler.enable = true;
	};

	# 修复Thunar不读取主题配置的bug
	programs.xfconf.enable = true;
	programs.dconf.enable = true;

	# 压缩包工具
	programs.file-roller.enable = true;

	environment.systemPackages = with pkgs; [
		xdg-utils
	];
}