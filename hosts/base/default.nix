{ pkgs, user, host, ... }: {
  nixpkgs.config.allowUnfree = true;

  fuzzing.enable = true;
  cntnr.enable = true;
  user = {
    inherit (user) username name;
  };
  networks = {
    hostname = host.hostname;
    firewall = {
      # enable = true;
      activeServices = [
        # "uxplay"
        "localsend"
      ];
    };
  };
  desktopmanager.enable = "gnome";
  displaymanager.enable = "gdm";
  #desktopManager.gnome.enable = true;
  #displayManager.gdm.enable = true;

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "chris"
      ];
    };
  };

  # :(
  #system.copySystemConfiguration = true;

  time.timeZone = "America/New_York";

  fonts.fontconfig.enable = true;

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

  # Workaround for GNOME autologin:
  #   https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd = {
    services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };
  };

  services = {
    xserver = {
      enable = true;

      # Enable the GNOME Desktop Environment.
      #desktopManager.gnome.enable = true;
      #displayManager.gdm.enable = true;

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

    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  security.rtkit.enable = true;

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
