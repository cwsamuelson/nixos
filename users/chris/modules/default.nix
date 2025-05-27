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
    ./home.nix
    ./kitty.nix
    ./neovim.nix
    ./vim.nix
    ./yazi.nix
  ];
}
