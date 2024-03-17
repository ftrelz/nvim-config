return {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
		if vim.fn.has("termguicolors") == 1
			then
				vim.cmd("set termguicolors")
			end

			vim.cmd("colorscheme catppuccin")
		end
}
