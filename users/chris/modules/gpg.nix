{ pkgs, config, ...}: {
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";

    # may want to change to true if it becomes an annoyance
    mutableKeys = false;
    mutableTrust = false;

    #settings = {
    #};
  };

  services.gpg-agent = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    # would like to setup gpg+ssh keys to have consistent, root identity keys
    #enableSshSupport = true;
    #sshKeys = [];
  };
}
