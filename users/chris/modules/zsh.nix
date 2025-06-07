{ pkgs, ... }: {
  #home.shell.enableZshIntegration = true;

  programs.zsh = {
    enable = true;

    enableCompletion = true;

    # plugin manager
    #antidote.enable = true;
    #antidote.plugins = [];
    #zplug...

    #plugins.*...

    autocd = true;
    #cdpath = [
    #  "projects"
    #  "repos"
    #  "wrappers"
    #];

    #autoSuggestions = {
    #};

    defaultKeymap = "viins";
    dotDir = ".config/zsh";

    history = {
      extended = true;
      ignoreAllDups = true;
      ignoreSpace = true;

      expireDuplicatesFirst = true;
      #findNoDups = true;
      #saveNoDups = true;
      share = true;
    };

    #oh-my-zsh = {
    #};

    syntaxHighlighting = {
    };
  };
}
