{
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    btop.enable = true;
    jq.enable = true;
    ripgrep.enable = true;
  };

  imports = [
    ./direnv.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./home-manager.nix
    ./home.nix
    ./kitty.nix
    ./neovim.nix
    ./nix-your-shell.nix
    ./shells
    ./tmux.nix
    ./todoman.nix
    ./vim.nix
    ./yazi.nix
  ];
}
