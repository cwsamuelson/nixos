return {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-wed-devicons', opt = true },
  config = function()
    require('lualine').setup({
      options = {
        theme = 'dracula'
      }
    })
  end
}
