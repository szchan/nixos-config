{ config, pkgs, ... }:

{   

	programs.dankMaterialShell = {
		enable = true;
		niri = {
			enableKeybinds = true;   # Sets static preset keybinds
			enableSpawn = true;      # Auto-start DMS with niri and cliphist, if enabled
		};

		enableSystemMonitoring = true;     # System monitoring widgets (dgop)
		enableClipboard = true;            # Clipboard history manager
		enableVPN = true;                  # VPN management widget
		enableDynamicTheming = true;       # Wallpaper-based theming (matugen)
		enableAudioWavelength = true;      # Audio visualizer (cava)
		enableCalendarEvents = true;       # Calendar integration (khal)

		default.settings = {
			theme = "dark";
			dynamicTheming = true;
			# Add any other settings here
		};

		default.session = {
			# Session state defaults
		};
	};

	systemd.user.services.niri-flake-polkit = {
		enable = false;  # 或直接 lib.mkForce false;
	};
}