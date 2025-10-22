{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # fwupd for framework
  services.fwupd.enable = true;
  services.fprintd.enable = true;

  boot = {
    loader = {
      grub.enable = false;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };

  # https://github.com/SteamNix/SteamNix/blob/main/configuration.nix
  # https://nixos.wiki/wiki/Steam
  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true;
  #   dedicatedServer.openFirewall = true;
  #   localNetworkGameTransfers.openFirewall = true;
  # };
}
