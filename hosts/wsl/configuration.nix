{ pkgs, ... }: {
  wsl = {
    enable = true;
    #nativeSystemd = 
    defaultUser = "chris";
    interop.includePath = true;
    wslConf = {
      boot.systemd = true;
      automount = {
        options = "metadata,uid=1000,gid=1000";
        root = "/mnt";
      };
    };
    useWindowsDriver = true;
    usbip.enable = true;
  };
}
