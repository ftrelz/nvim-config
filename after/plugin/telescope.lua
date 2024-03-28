local telescope = require("telescope")

telescope.setup({
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key"
            }
        }
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
})

telescope.load_extension("fzf")

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

