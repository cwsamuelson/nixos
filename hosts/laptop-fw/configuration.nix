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
}
