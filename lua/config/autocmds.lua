-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

vim.api.nvim_create_augroup("fred", { clear = true })
vim.api.nvim_create_autocmd("BufLeave", {
  group = "fred",
  pattern = "*",
  desc = "Manages marks for jumping to previous buffer",
  callback = function(event)
    local cursorpos = vim.api.nvim_win_get_cursor(0)
    if not vim.api.nvim_buf_set_mark(event.buf, "A", cursorpos[1], cursorpos[2], {}) then
      vim.notify("Error setting mark in buffer " .. event.file)
    end
  end,
})

vim.api.nvim_create_augroup("localconfig", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", {
  group = "localconfig",
  pattern = "*",
  desc = "Load .local-nvim-config.lua if it exists",
  callback = function()
    local localNvimFilePaths = vim.fs.find({ ".local-nvim-config.lua" }, { type = "file" })

    if next(localNvimFilePaths) ~= nil then
      vim.cmd("so " .. localNvimFilePaths[1])
    end
  end,
})
