return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig"
    },
    config = function()
      require("mason").setup()
      local mlsp = require("mason-lspconfig")
      local desired = {
        "lua_ls",
        "bashls",
        "clangd",
        "cmake"
      }
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
        ensure_installed = available,
        handlers = {
          function(server_name)
            vim.lsp.config(server_name, {})
          end,
          lua_ls = function()
            vim.lsp.config("lua_ls", {
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
          end,
          clangd = function()
            vim.lsp.config("clangd", {
              cmd = { "clangd", "--background-index", "--clang-tidy" },
              filetypes = { "c", "cpp", "cc", "h", "hh", "hpp", "objc", "objcpp" },
              root_markers = { "compile_commands.json", ".git" },
            })
          end,
        }
      })

      vim.keymap.set('n', '<leader>d', ':Telescope diagnostics<CR>', {})
    end
  },
}
