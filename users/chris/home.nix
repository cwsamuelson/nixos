{ stateVersion, username, ... }: {
  imports = [
    ./modules
    ./packages.nix
  ];

  home = {
    homeDirectory = "/home/${user}";
    inherit username stateVersion;
  };
}
