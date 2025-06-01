{ pkgs, stateVersion, username, system, init-bash, ... }:
let
  orig = init-bash;

  userScripts = pkgs.runCommand "apps" {} ''
    mkdir -p $out
    echo "#!/usr/bin/env bash" > $out/my-script
    echo "echo hello from my script!" >> $out/my-script
    chmod +x $out/my-script
  '';

  fullWrapped = pkgs.runCommand "wrapped-apps" {} ''
    mkdir $out/bin
    cp -r ${orig}/bin/* $out/bin/

    mkdir -p $out/bin/apps
    cp -r ${userScripts}/* $out/bin/apps
  '';
in
{
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
  };

  imports = [
    ./modules
    ./packages.nix
  ];

  home = {
    homeDirectory = "/home/${username}";
    inherit username stateVersion;
    #packages = [
    #  fullWrapped
    #];
  };
}
