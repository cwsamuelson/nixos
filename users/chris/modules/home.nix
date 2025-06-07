{ pkgs, user, stateVersion, ... }: {
  home = {
    homeDirectory = "/home/${user.username}";
    stateVersion = user.stateVersion;
    username = user.username;

    file = {
      ".inputrc".source = ../dotfiles/inputrc;
    };

    sessionVariables = {
      CONAN_PASSWORD="demo";
      CONAN_LOGIN_USERNAME="demo";
      DIRENV_LOG_FORMAT="";
    };
   
    # color=always can cause problems sometimes :(
    # piping to commands and files will include the command characters
    # my usage of these commands doesn't typically run into that problem
    shellAliases = {
      # search on path
      # how to accept arguments?
      # name = "find ${PATH//:/\/ } -iname 'search term'
      # create variation of search using arbitrary var?
      # search as array:
      # name = "find \"${array[@]}\" -iname "$file"

      switch-home = "home-manager switch --flake ~/projects/nixos";
      switch-os = "nixos-rebuild switch --flake ~/projects/nixos";
      # -l list vertically, with add metadata
      # -h human readable file sizes
      # -A 'all', but excluding '.' and '..'
      ls = "ls -lhA --color=always";
      # -I skip binary files
      # -n include line numbers
      # -r recursive
      # -i case insensitive
      grep = "grep -Ini --color=always";
      oops = "sudo $(history -p !!)";
      cat = "bat --wrap=never";
      dbr = "devbox run";
      docker-clean = "docker system df && docker container prune -f -a && docker image prune -f && docker builder prune -f && docker volume prune -a -f && docker system df";
      podman-clean = "podman system df && podman container prune -f && podman image prune -f && podman builder prune -f && podman volume prune -f && podman system df";
    };
  };
}
