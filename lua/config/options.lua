-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.scrolloff = 8
vim.opt.colorcolumn = "80"
vim.opt.splitright = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.expandtab = true

vim.api.nvim_create_user_command(
  "Scratch",
  "new +setlocal\\ buftype=nofile +setlocal\\ bufhidden=hide +setlocal\\ noswapfile",
  {}
)
