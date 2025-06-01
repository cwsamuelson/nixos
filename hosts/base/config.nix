{ pkgs, hostname, ... }: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  imports = [
    ./afl.nix
  ];

  # :(
  #system.copySystemConfiguration = true;

  time.timeZone = "America/New_York";

  # I don't think this belongs here anyway..
  #nixGL.packages = nixgl.packages;
 
  fonts.fontconfig.enable = true;

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

  boot.loader.grub.enable = false;

  networking = {
    networkmanager.enable = true;

    hostName = hostname;

    # Open ports in the firewall.
    #   53317 is for localsend
    # firewall.allowedTCPPorts = [ 53317 ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # Workaround for GNOME autologin:
  #   https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd = {
    services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };

  services = {
    displayManager = {
      # Enable automatic login
      autoLogin = {
        enable = true;
        user = "chris";
      };
    };

    xserver = {
      enable = true;

      # Enable the GNOME Desktop Environment.
      desktopManager.gnome.enable = true;
      displayManager.gdm.enable = true;

      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "dvp";
      };

      # Enable touchpad support (enabled default in most desktopManager).
      # libinput.enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable the OpenSSH daemon.
    # openssh.enable = true;
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    git
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

  system.stateVersion = "23.11";
}
