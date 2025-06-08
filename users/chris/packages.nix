{ pkgs, ... }: {
  home.packages = with pkgs; [
    # UI
    firefox
    gitkraken
    jetbrains-toolbox
    obsidian

    # dev
    stdman
    tre-command
    devbox
    copier

    # utility
    curl
    yq

    fd
    most
    hishtory
    binsider

    # delta?
    # https://github.com/dandavison/delta

    ## advanced watch
    # viddy

    ## tui baobab tools
    # wiper
    # dua
    # diskonaut
  ];
}
