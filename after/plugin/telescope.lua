local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags"})
vim.keymap.set("n", "<leader>gs", function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end, { desc = "Show grep prompt to search" })
vim.keymap.set("n", "<leader>fm", function() builtin.man_pages({ sections = { "ALL" } }) end, { desc = "Search manpages" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find keymaps" })
vim.keymap.set("n", "<leader>fd", function() builtin.diagnostics({ bufnr = 0 }) end, { desc = "Find lsp diagnostics" })
vim.keymap.set("n", "<leader>fq", builtin.quickfixhistory, { desc = "Show last 10 quickfix lists" })

