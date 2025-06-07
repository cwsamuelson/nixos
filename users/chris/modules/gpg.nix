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

    #enableSshSupport = true;
    #sshKeys = [];
  };
}
