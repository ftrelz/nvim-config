local lsp = require('lsp-zero').preset("recommended")

lsp.on_attach(function(_, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp.default_keymaps({ buffer = bufnr })
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
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup(lsp.nvim_lua_ls({
    settings = {
        Lua = {
            completion = {
                callSnippet = "Replace"
            }
        }
    }
}))

lspconfig.tsserver.setup({
    keys = {
        {
            "<leader>co",
            function()
                vim.lsp.buf.code_action({
                    apply = true,
                    context = {
                        only = { "source.organizeImports.ts" },
                        diagnostics = {},
                    },
                })
            end,
            desc = "Organize Imports",
        },
        {
            "<leader>cR",
            function()
                vim.lsp.buf.code_action({
                    apply = true,
                    context = {
                        only = { "source.removeUnused.ts" },
                        diagnostics = {},
                    },
                })
            end,
            desc = "Remove Unused Imports",
        },
    },
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

lspconfig.tailwindcss.setup({})

lspconfig.emmet_language_server.setup({
    init_options = {
        syntax_profiles = {
            jsx = "xhtml"
        }
    }
})

lspconfig.jsonls.setup({
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
        vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    settings = {
        json = {
            format = {
                enable = true,
            },
            validate = { enable = true },
        },
    },
})

lspconfig.clangd.setup({
    keys = {
        { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
    },
    root_dir = function(fname)
        return require("lspconfig.util").root_pattern(
            "Makefile",
            "configure.ac",
            "configure.in",
            "config.h.in",
            "meson.build",
            "meson_options.txt",
            "build.ninja"
        )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
            fname
        ) or require("lspconfig.util").find_git_ancestor(fname)
    end,
    capabilities = {
        offsetEncoding = { "utf-16" },
    },
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm",
    },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
    },
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
