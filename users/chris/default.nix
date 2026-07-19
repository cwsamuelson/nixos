{ pkgs, user, ... }:
let
  packagesModule = import ./packages.nix { inherit pkgs; };
in
packagesModule // {
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    btop.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    difftastic.enable = true;

    lazydocker.enable = true;
    lazysql.enable = true;
    password-store.enable = true;
  };

  direnv.enable = true;
  fzf.enable = true;
  git.enable = true;
  gpg.enable = true;
  kitty.enable = true;
  mail.enable = true;
  nys.enable = false;
  ranger.enable = true;
  shells.enable = "bash";
  yazi.enable = false;

  home = packagesModule.home // {
    file = {
      ".inputrc".source = ./dotfiles/inputrc;
    };

    sessionVariables = {
      CONAN_PASSWORD="demo";
      CONAN_LOGIN_USERNAME="demo";
      DIRENV_LOG_FORMAT="";
    };

    # color=always can cause problems sometimes :(
    # piping to commands and files will include the command characters
    # my usage of these commands doesn't typically run into that problem
    shellAliases = with pkgs; {
      # search on path
      # how to accept arguments?
      # name = "find ${PATH//:/\/ } -iname 'search term'
      # create variation of search using arbitrary var?
      # search as array:
      # name = "find \"${array[@]}\" -iname "$file"

      # When stand-alone, may want to run as `switch-home --extra-experimental-features 'nix-command flakes'`
      switch-home = "${home-manager}/bin/home-manager switch --flake ~/projects/nixos";
      switch-os = "nixos-rebuild switch --flake ~/projects/nixos";

      # This is hypothetical, for now..
      # clean-nix = "nix-env --list-generations";
      # clean-nix = "nix-collect-garbage --delete-old";

      # -l list vertically, with add metadata
      # -h human readable file sizes
      # -A 'all', but excluding '.' and '.''
      ls = "ls -lhA --color=always";

      diff = "difft";

      # -I skip binary files
      # -n include line numbers
      # -i case insensitive
      grep = "grep -Ini --color=always --exclude-dir={.git,.venv,.devbox,.devenv,build,.obsidian,.conan,.conan2,.svn}";
      oops = "sudo $(history -p !!)";
      cat = "${bat}/bin/bat --wrap=never";
      docker-clean = "docker system df && docker container prune -f -a && docker image prune -f && docker builder prune -f && docker volume prune -a -f && docker system df";
      podman-clean = "podman system df && podman container prune -f && podman image prune -f && podman builder prune -f && podman volume prune -f && podman system df";
    };
  };
}
