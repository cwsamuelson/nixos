{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.vim;
in
{
  options.vim = {
    enable = mkEnableOption "vim configuration";
  };

  config = mkIf cfg.enable {
    programs.vim = {
      enable = false;
      defaultEditor = false;

      settings = {
        expandtab = true;
        number = true;
        relativenumber = true;
        tabstop = 2;
        shiftwidth = 2;
        mouse = "a";
        ignorecase = true;
        smartcase = true;
      };

      extraConfig = ''
        set nocompatible
        set scrolloff=8
      '';
    };
  };
}