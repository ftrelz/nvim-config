local lsp = require('lsp-zero').preset("recommended")

lsp.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp.default_keymaps({buffer = bufnr})
end)

lsp.ensure_installed({
	"clangd",
	"cssls",
	"eslint",
	"html",
	"jsonls",
    "tailwindcss",
    "tsserver",
	"pylsp",
    "emmet_language_server"
})

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls({
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            }
        }
    }
}))
require('lspconfig').tsserver.setup({
    settings = {
        typescript = {
            format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
            },
        },
        javascript = {
            format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
            },
        },
        completions = {
            completeFunctionCalls = true,
        },
    },
})
require('lspconfig').emmet_language_server.setup({
    init_options = {
        syntax_profiles = {
            jsx = "xhtml"
        }
    }
})

lsp.setup()

lsp.format_on_save({
    servers = {
        ["clangd"] = { "c", "cpp" },
        ["tsserver"] = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        ["html"] = { "html" },
        ["jsonls"] = { "json" }
    }
})

