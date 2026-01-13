{ pkgs, user, ... }:
  import ./packages.nix { inherit pkgs user; }
// {
  shells.enable = "bash";

  programs = {
    lazygit.enable = true;
    lazydocker.enable = true;
    # HM manual says this exists, but it doesn't build
    lazysql.enable = true;
    ranger.enable = true;
    password-store.enable = true;
  };
}
