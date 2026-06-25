{ pkgs, lib, config, ... }: {
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    withPython3 = true;
    withRuby = false;
  };

  home.sessionVariables.EDITOR = lib.mkIf config.programs.neovim.enable (lib.mkForce "nvim -p");

  xdg.configFile."nvim".source = ./config;
}
