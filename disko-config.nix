{
    disko.devices = {
        disk = {
            main = {
                type = "disk";
                device = "/dev/nvme0n1";
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            priority = 1;
                            name = "ESP";
                            start = "1M";
                            end = "128M";
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
                                    "@varlog" = {
                                        mountOptions = [
                                            "compress=zstd"
                                            "noatime"
                                        ];
                                        mountpoint = "/var/log";
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
                                            swapfile.size = "32G";
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
};
