return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local mlsp = require("mason-lspconfig")
      local desired = { "lua_ls", "bashls", "clangd", "cmake" }

      local available = vim.tbl_filter(function(s)
        return vim.tbl_contains(mlsp.get_available_servers(), s)
      end, desired)

      local missing = vim.tbl_filter(function(s)
        return not vim.tbl_contains(available, s)
      end, desired)

      if #missing > 0 then
        vim.notify("Skipping Mason install for unsupported languages: " .. table.concat(missing, ", "), vim.log.levels.WARN)
      end

      mlsp.setup({
        ensure_installed = available
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false
            },
          }
        }
      })
      lspconfig.clangd.setup({
        cmd = { "clangd", "--compile-commands-dir=build" },
      })

      vim.keymap.set('n', '<leader>d', ':Telescope diagnostics<CR>', {})
    end
  }
}
