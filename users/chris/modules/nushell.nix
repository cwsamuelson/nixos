{ pkgs, system, dotscripts, ... }: {
  #home.shell.enableNushellIntegration = true;

  programs.nushell = {
    enable = true;
  };
}
