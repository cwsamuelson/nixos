return {
  "kelly-lin/ranger.nvim",
  config = function()
    local rnvim = require("ranger-nvim")
    rnvim.setup({ replace_netrw = true })

    vim.api.nvim_set_keymap("n", "<leader>ef", "", {
      noremap = true,
      callback = function()
        rnvim.open(true)
      end
    })
  end
}
