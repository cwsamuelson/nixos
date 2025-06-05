{ pkgs, config, stateVersion, username, system, init-bash, ... }:
let
  dotscripts = import ./dotfiles { inherit pkgs init-bash; };
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
