return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        lazy = true,
        config = false,
        init = function()
            -- Disable automatic setup, we are doing it manually
            vim.g.lsp_zero_extend_cmp = 0
            vim.g.lsp_zero_extend_lspconfig = 0
        end,
    },
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = true,
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "L3MON4D3/LuaSnip" },
        },
        config = function()
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_cmp()

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local luasnip = require("luasnip")
            -- And you can configure cmp even more, if you want to.
            local cmp = require("cmp")

            cmp.setup({
                formatting = lsp_zero.cmp_format({ details = true }),
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<S-CR>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ["<C-CR>"] = function(fallback)
                        cmp.abort()
                        fallback()
                    end,
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                            -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                            -- that way you will only jump inside the snippet region
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
            })
        end,
        opts = function(_, opts)
            opts.sorting = require("cmp.config.default")().sorting
            table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
        end
    },
    {
        "neovim/nvim-lspconfig",
        cmd = { "LspInfo", "LspInstall", "LspStart" },
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp" },
            { "williamboman/mason-lspconfig.nvim" },
            { "folke/neodev.nvim" }
        },
        config = function()
            -- This is where all the LSP shenanigans will live
            local lsp_zero = require("lsp-zero")
            lsp_zero.extend_lspconfig()

            --- if you want to know more about lsp-zero and mason.nvim
            --- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
            lsp_zero.on_attach(function(client, bufnr)
                -- see :help lsp-zero-keybindings
                -- to learn the available actions
                if (client.name == "clangd") then
                    lsp_zero.default_keymaps({
                        buffer = bufnr,
                        preserve_mappings = false,
                        exclude = { "K" }
                    })

                    require("clangd_extensions.inlay_hints").setup_autocmd()
                    require("clangd_extensions.inlay_hints").set_inlay_hints()
                else
                    lsp_zero.default_keymaps({
                        buffer = bufnr,
                        preserve_mappings = false
                    })
                end
            end)

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "cssls",
                    "eslint",
                    "html",
                    "jsonls",
                    "marksman",
                    "tailwindcss",
                    "tsserver",
                    "pylsp",
                    "emmet_language_server"
                },
                handlers = {
                    lsp_zero.default_setup,
                    lua_ls = function()
                        local lua_opts = lsp_zero.nvim_lua_ls({
                            settings = {
                                Lua = {
                                    completion = {
                                        callSnippet = "Replace"
                                    }
                                }
                            }
                        })
                        require("lspconfig").lua_ls.setup(lua_opts)
                    end,
                    tsserver = function()
                        require("lspconfig").tsserver.setup({
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
                    end,
                    tailwindcss = function()
                        require("lspconfig").tailwindcss.setup({})
                    end,
                    emmet_language_server = function()
                        require("lspconfig").emmet_language_server.setup({
                            init_options = {
                                syntax_profiles = {
                                    jsx = "xhtml"
                                }
                            }
                        })
                    end,
                    jsonls = function()
                        require("lspconfig").jsonls.setup({
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
                    end,
                    clangd = function()
                        require("lspconfig").clangd.setup({
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
                                    )(fname) or
                                    require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
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
                    end,
                    marksman = function()
                        require("lspconfig").marksman.setup({})
                    end
                }
            })

            lsp_zero.format_on_save({
                servers = {
                    ["clangd"] = { "c", "cpp" },
                    ["tsserver"] = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
                    ["html"] = { "html" },
                    ["jsonls"] = { "json" },
                    ["lua_ls"] = { "lua" }
                }
            })
        end
    }
}
