{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  gui.enable = true;
  gpg.enable = true;

  services = {
    # fwupd for framework
    fwupd.enable = true;
    fprintd.enable = true;

    # nfs support
    rpcbind.enable = true;
  };

  boot = {
    # nfs support
    supportedFilesystems = [ "nfs" ];

    loader = {
      grub.enable = false;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;
  };
}
