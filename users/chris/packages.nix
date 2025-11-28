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
    devenv
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

    structurizr-cli

    # # https://git.zx2c4.com/ctmg/about/
    # ctmg
    # cryptsetup

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
