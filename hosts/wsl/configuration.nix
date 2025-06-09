{ pkgs, user, nixos-wsl, ... }: {
  imports = [
    nixos-wsl.nixosModules.default
    # ??
    #nixos-wsl.nixosModules.wsl
  ];

  wsl = {
    enable = true;
    #nativeSystemd = 
    defaultUser = user.username;
    interop.includePath = true;
    wslConf = {
      boot = {
        systemd = true;
        grub.enable = false;
      };
      automount = {
        options = "metadata,uid=1000,gid=1000";
        root = "/mnt";
      };
    };
    useWindowsDriver = true;
    usbip.enable = true;
  };
}
