{ pkgs, ... }: {
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

  xdg.configFile."nvim".source = ./config;
}
