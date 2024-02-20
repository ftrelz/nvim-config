vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Allows moving highlighted lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Allows moving highlighted lines up" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Appends the next line to the current line with a space" } )
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page jump down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page jump up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "When searching, current found instance remains in middle of screen" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "When sesarching, current found instance remains in middle of screen" })

vim.keymap.set("x", "<leader>p", "\"_dP", { desc = "Paste over highlighted word without replacing copy register contents" })

vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Copy to system clipboard"})
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Copy to system clipboard"})
vim.keymap.set("n", "<leader>Y", "\"+y", { desc = "Copy to system clipboard"})

vim.keymap.set("n", "<leader>ss", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>", { desc = "Search and replace term under cursor" })
vim.keymap.set("v", "<leader>sm", "y:%s/<C-R>\"/<C-R>\"/gI<Left><Left><Left>", { desc = "Search and replace highlighted section" })

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape terminal mode" })

vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Move to left window from terminal mode" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Move to lower window from terminal mode" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Move to upper window from terminal mode" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Move to right window from terminal mode" })

vim.keymap.set("n", "<leader>p", "'A", { desc = "fredgroup autocmd: jump to previous buffer" })

