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
    ./gpg.nix
    ./home-manager.nix
    ./home.nix
    ./kitty.nix
    ./neovim.nix
    ./nix-your-shell.nix
    ./nushell.nix
    ./tmux.nix
    ./todoman.nix
    ./vim.nix
    ./yazi.nix
    ./zsh.nix
  ];
}
