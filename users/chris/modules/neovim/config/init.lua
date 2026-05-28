local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")

require("lazy").setup("plugins")

-- Auto-open alternate file in split on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only run if exactly one file was opened
    if vim.fn.argc() == 1 and vim.fn.filereadable(vim.fn.argv(0)) == 1 then
      vim.defer_fn(function()
        -- Try to open alternate with projectionist
        local ok = pcall(vim.cmd, 'AV')
        if not ok then
          -- Fallback: manual search
          local current = vim.fn.expand('%:p')
          local base = vim.fn.fnamemodify(current, ':t:r')
          local dir = vim.fn.fnamemodify(current, ':h:h')

          if current:match('/header/') then
            local alt = vim.fn.glob(dir .. '/source/' .. base .. '.*')
            if alt ~= '' then
              vim.cmd('vsplit ' .. alt)
            end
          elseif current:match('/source/') then
            local alt = vim.fn.glob(dir .. '/header/' .. base .. '.*')
            if alt ~= '' then
              vim.cmd('vsplit ' .. alt)
            end
          end
        end
      end, 10)
    end
  end
})
