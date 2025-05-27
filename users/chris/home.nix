{ stateVersion, username, ... }: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./modules
    ./packages.nix
  ];

  home = {
    homeDirectory = "/home/${username}";
    inherit username stateVersion;
  };
}
