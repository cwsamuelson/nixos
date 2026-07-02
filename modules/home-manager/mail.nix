{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.mail;
in
{
  options.mail = {
    enable = mkEnableOption "Mail configuration";
  };

  config = mkIf cfg.enable {
    # Nothing yet.
    # - Automatic GPG signing
    # - Work with GMail
  };
}
