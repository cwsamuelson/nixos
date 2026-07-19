{ pkgs, ... }: {
  home.packages = with pkgs; [
    age
    age-plugin-yubikey

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

    # regex101.com substitutes:
    rgx # also allows for grep-like filtering
    # regex-tui # perhaps TOO minimal
    # rexi # uses python's textual framework
    # grex # specifically GENERATES regexes from input

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

    # # proton?
    # proton-pass
    # protonvpn-gui
    # protonmail-bridge
    # protonmail-desktop
    # proton-authenticator

    # yubico-PAM
    # yubikey-agent
    # yubikey-manager
    # libyubikey
    # libykclient

    # # https://secretspec.dev/
    # # https://devenv.sh/integrations/secretspec/#configuration-optional
    lastpass-cli
    # secretspec
    pass

    # # https://git.zx2c4.com/ctmg/about/
    # ctmg
    # cryptsetup

    # https://github.com/dandavison/delta
    # delta?

    # # advanced watch
    # viddy

    # # tui baobab tools
    # wiper
    # dua
    # diskonaut
  ];
}
