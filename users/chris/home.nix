{ pkgs, user, ... }:
  import ./packages.nix { inherit pkgs user; }
// {
  shells.enable = "bash";

  programs = {
    home-manager.enable = true;
    bat.enable = true;
    btop.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
    difftastic.enable = true;

    lazydocker.enable = true;
    # HM manual says this exists, but it doesn't build
    lazysql.enable = true;
    ranger.enable = true;
    password-store.enable = true;
  };
}
