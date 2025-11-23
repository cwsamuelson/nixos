{ pkgs, config, ...}: {
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";

    mutableKeys = true;
    mutableTrust = false;

    #settings = {
    #};
  };

  home.packages = with pkgs; [
    # pinentry
  ];

  services.gpg-agent = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    pinentry = {
      package = pkgs.pinentry-curses;
    };

    # would like to setup gpg+ssh keys to have consistent, root identity keys
    #enableSshSupport = true;
    #sshKeys = [];
  };
}
