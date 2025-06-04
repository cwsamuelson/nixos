{ pkgs, config, stateVersion, username, system, init-bash, ... }:
let
  userScripts = pkgs.runCommand "apps" {} ''
    mkdir -p $out
    echo "#!/usr/bin/env bash" > $out/my-script
    echo "echo hello from my script!" >> $out/my-script
    chmod +x $out/my-script
  '';
in
{
  imports = [
    ./dotfiles
    ./modules
    ./packages.nix
  ];

  config._module.args = {
    inherit username stateVersion init-bash;
  };
}
