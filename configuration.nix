{ config, pkgs, ... }: {
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

  boot.loader.grub.enable = false;

  networking = {
    networkmanager.enable = true;

    hostName = "chris-desktop-wsl";
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  users.users.chris = {
    isNormalUser = true;
    uid = 1000;
    #primaryGroup = "chris";
    description = " Chris Samuelson";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      home-manager
    ];
  };

  users.groups.chris = {
    gid = 1000;
  };

  environment.systemPackages = with pkgs; [
    vim
    git # for flakes
    wget
  ];

  programs = {
    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        gcc13
      ];
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?
}

