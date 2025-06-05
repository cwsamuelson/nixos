{ pkgs, system, dotscripts, ... }: {
  programs.bash = {
    enable = true;

    enableCompletion = true;
 
    historyControl = [
      "ignorespace"
      "ignoredups"
      "erasedups"
    ];

    historyIgnore = [
      "fg"
      "fg *"
      "* --help"
      "incognito"
      "echo *"
    ];

    shellOptions = [
      "-histappend"
      "histverify"
      "autocd"
      "checkjobs"
      "checkwinsize"
      "extglob"
      "globstar"
    ];

    # manual additions to bash_profile
    profileExtra = ''
      source ${dotscripts}/bin/init.bash
    '';

    # manual additions to bashrc
    initExtra = ''
      source ${dotscripts}/bin/init.bash
    '';
  };
}
