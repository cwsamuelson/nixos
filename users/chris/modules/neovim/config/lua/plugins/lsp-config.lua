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
        ensure_installed = available
      })

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
        -- cmd = { "clangd", "--clang-tidy" },
        -- cmd = { "clangd", "--compile-commands-dir=build", "--clang-tidy" },
        cmd = { "clangd", "--background-index", "--clang-tidy" },
        filetypes = { "c", "cpp", "cc", "h", "hh", "hpp", "objc", "objcpp" },
        root_dir = lspconfig.util.root_pattern("compile_commands.json", ".git"),
      })

      vim.keymap.set('n', '<leader>d', ':Telescope diagnostics<CR>', {})
    end
  },
}
