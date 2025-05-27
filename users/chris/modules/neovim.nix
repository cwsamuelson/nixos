{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    # Additional plugin engines available
    #withNodeJs = true;
    #withPython3 = true;
    #withRuby = true;

    plugins = 
    let
      nvim-treesitter-with-plugins = pkgs.vimPlugins.nvim-treesitter.withPlugins (treesitter-plugins:
        with treesitter-plugins; [
          bash
          c
          cpp
          lua
          nix
          python
        ]);
    in
    with pkgs.vimPlugins; [
      # https://github.com/LukasPietzschmann/telescope-tabs
      telescope-nvim
      telescope-fzf-native-nvim
      nvim-treesitter-with-plugins

      #yazi-nvim

      # fromGithub defined above; use to pull plugins from github
      #(fromGithub "HEAD" "user/project.nvim")
    ];

    extraConfig = ''
      set nocompatible
      set mouse=a
      set expandtab
      set tabstop=2
      set shiftwidth=2

      set number
      set relativenumber

      set scrolloff=8

      set ignorecase
      set smartcase

      colorscheme torte
   '';

   extraLuaConfig = ''
     -- hotkey for yazi overlay
     vim.api.nvim_set_keymap('n', '<leader>y', ':Yazi<CR>', { noremap = true, silent = true })
   '';
  };
}
