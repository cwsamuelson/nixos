{ pkgs, config, stateVersion, username, system, init-bash, ... }:
let
  userScripts = pkgs.runCommand "apps" {} ''
    mkdir -p $out
    echo "#!/usr/bin/env bash" > $out/my-script
    echo "echo hello from my script!" >> $out/my-script
    chmod +x $out/my-script
  '';

  fullWrapped = pkgs.runCommand "wrapped-apps" {} ''
    mkdir -p $out/bin
    cp -r ${init-bash.packages.${system}.default}/bin/* $out/bin

    mkdir -p $out/bin/apps
    cp -r ${userScripts}/* $out/bin/apps
  '';
in
{
  imports = [
    ./modules
    ./packages.nix
  ];

  config._module.args = {
    inherit username stateVersion fullWrapped;
  };
}
