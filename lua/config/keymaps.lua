-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

if vim.g.neovide then
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode

  vim.g.neovide_scale_factor = 0.9
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.25)
  end)

  vim.keymap.set("n", "<leader>np", function()
    vim.g.neovide_profiler = not vim.g.neovide_profiler
  end)
end

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Allows moving highlighted lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Allows moving highlighted lines up" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page jump down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page jump up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "When searching, current found instance remains in middle of screen" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "When sesarching, current found instance remains in middle of screen" })

vim.keymap.set(
  "x",
  "<leader>p",
  '"_dP',
  { desc = "Paste over highlighted word without replacing copy register contents" }
)

-- vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
-- vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
-- vim.keymap.set("n", "<leader>Y", '"+y', { desc = "Copy to system clipboard" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape terminal mode" })

vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Move to left window from terminal mode" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Move to lower window from terminal mode" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Move to upper window from terminal mode" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Move to right window from terminal mode" })

vim.keymap.set("n", "<leader>p", "'A", { desc = "fredgroup autocmd: jump to previous buffer" })

vim.keymap.set("n", "S-h", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "S-l", ":bprev<CR>", { desc = "Prev buffer" })
