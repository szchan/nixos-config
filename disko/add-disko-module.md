When editing configuration.nix, you will need to add the disko NixOS module and disk-config.nix to the imports section. This section will already include the file ./hardware-configuration.nix, and you can add the new entries just below this. This section will now include:

编辑configuration.nix时，你需要添加disko NixOS 模块和disk-config.nix到导入部分。本节已经 包含文件./hardware-configuration.nix，你可以添加新的条目 就在这下面。本节现将包括：

imports =
 [ # Include the results of the hardware scan.
   ./hardware-configuration.nix
   "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
   ./disk-config.nix
 ];