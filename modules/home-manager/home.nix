{ pkgs, user, stateVersion, ... }:
{
  home = {
    homeDirectory = "/home/${user.username}";
    stateVersion = user.stateVersion;
    username = user.username;
  };
}