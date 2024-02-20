-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- OR setup with some options
require("nvim-tree").setup({
  view = {
    width = 30,
  },
})

--vim.cmd("highlight Normal ctermbg=none guibg=none")
--vim.cmd("highlight NormalFloat ctermbg=none guibg=none")
--vim.cmd("highlight NormalNC ctermbg=none guibg=none")
--vim.cmd("highlight EndOfBuffer ctermbg=none guibg=none")
--vim.cmd("highlight NvimTreeNormal ctermbg=none guibg=none")
--vim.cmd("highlight NvimTreeNormalFloat ctermbg=none guibg=none")
--vim.cmd("highlight NvimTreeEndOfBuffer ctermbg=none guibg=none")
