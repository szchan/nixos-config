{
	disko.devices = {
		disk = {
			main = {
				type = "disk";
				device = "/dev/vda";
				content = {
					type = "gpt";
					partitions = {
						ESP = {
							priority = 1;
							name = "ESP";
							start = "1M";
							end = "1024M";
							type = "EF00";
							content = {
								type = "filesystem";
								format = "vfat";
								mountpoint = "/boot";
								mountOptions = [ "umask=0077" ];
							};
						};
						root = {
							size = "100%";
							content = {
								type = "btrfs";
								extraArgs = [ "-f" ];
								subvolumes = {
									"@root" = {
										mountOptions = [
											"compress=zstd"
											"noatime"
										];
										mountpoint = "/";
									};
									"@home" = {
										mountOptions = [
											"compress=zstd"
											"noatime"
										];
										mountpoint = "/home";
									};
									"@nix" = {
										mountOptions = [
											"compress=zstd"
											"noatime"
										];
										mountpoint = "/nix";
									};
									"@var" = {
										mountOptions = [
											"compress=zstd"
											"noatime"
										];
										mountpoint = "/var";
									};
									"@tmp" = {
										mountOptions = [
											"compress=zstd"
											"noatime"
										];
										mountpoint = "/tmp";
									};
									"@swap" = {
										mountpoint = "/swap";
										swap = {
											swapfile.size = "40G";
										};
									};
								};
							};
						};
					};
				};
			};
		};
	};
}
