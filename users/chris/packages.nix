{ pkgs, ... }: {
  home.packages = with pkgs; [
    # UI
    firefox
    gitkraken
    jetbrains-toolbox
    icu # in support of CLion..
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
    bc
    usbutils
    nushell

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
