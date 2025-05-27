{ pkgs, ... }: {
  home.packages = with pkgs; [
    firefox
    gitkraken
    jetbrains-toolbox
    stdman
    obsidian

    curl
    fd
    # delta?
    # https://github.com/dandavison/delta
    most
    yq
    hishtory
    copier
    binsider
    ## advanced watch
    # viddy
    ## tui baobab tools
    # wiper
    # dua
    # diskonaut
    tre-command
 
    devbox
  ];
}
