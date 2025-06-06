{ pkgs, config, stateVersion, username, system, ... }:
let
  dotscripts = import ./dotfiles { inherit pkgs; };
in
{
  imports = [
    ./modules
    ./packages.nix
  ];

  config._module.args = {
    inherit username stateVersion dotscripts;
  };
}
