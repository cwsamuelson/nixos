{ pkgs, ... }: {
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    #enableNushellIntegration = true;

    defaultCommand = "fd --type f";
  };
}
