{ pkgs, nixos-wsl, ... }: {
  imports = [
    nixos-wsl.nixosModules.wsl
    ./hardware-configuration.nix
  ];

  # fwupd for framework
  services.fwupd.enable = true;
  services.fprintd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

}
