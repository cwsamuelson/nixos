{
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    btop.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
  };

  imports = [
    ./bash.nix
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./yazi.nix
  ];
}
