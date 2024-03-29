return {
    "nvimtools/none-ls.nvim",
    dependancies = { "jose-elias-alvarez/null-ls" },
    optional = true,
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.markdownlint,
      })
    end,
}
