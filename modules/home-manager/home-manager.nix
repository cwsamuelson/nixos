{ pkgs, ... }: {
  services.home-manager.autoExpire = {
    enable = true;

    #Failed to start unit home-manager-auto-expire.timer
    #org.freedesktop.systemd1.BadUnitSetting: Unit home-manager-auto-expire.timer has a bad unit file setting.
    #frequency = "2 weeks";
    timestamp = "-30 days";
  };
}
