---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
    local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
    config = vim.deepcopy(config)
    ---@cast args string[]
    config.args = function()
        local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
        return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
    end
    return config
end

return {
    'mfussenegger/nvim-dap',
    lazy = true,
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            lazy = true,
            event = "VeryLazy",
            dependencies = { "nvim-neotest/nvim-nio" },
            keys = {
                { "<leader>du", function() require("dapui").toggle({}) end, desc = "Dap UI" },
                { "<leader>de", function() require("dapui").eval() end,     desc = "Eval",  mode = { "n", "v" } },
            },
            opts = {},
            config = function(_, opts)
                local dap = require("dap")
                local dapui = require("dapui")
                dapui.setup(opts)
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open({})
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close({})
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close({})
                end
            end,
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            opts = {},
        },
        {
            "jbyuki/one-small-step-for-vimkind",
            -- stylua: ignore
            config = function()
                local dap = require("dap")
                dap.adapters.nlua = function(callback, conf)
                    local adapter = {
                        type = "server",
                        host = conf.host or "127.0.0.1",
                        port = conf.port or 8086,
                    }
                    if conf.start_neovim then
                        local dap_run = dap.run
                        dap.run = function(c)
                            adapter.port = c.port
                            adapter.host = c.host
                        end
                        require("osv").run_this()
                        dap.run = dap_run
                    end
                    callback(adapter)
                end
                dap.configurations.lua = {
                    {
                        type = "nlua",
                        request = "attach",
                        name = "Run this file",
                        start_neovim = {},
                    },
                    {
                        type = "nlua",
                        request = "attach",
                        name = "Attach to running Neovim instance (port = 8086)",
                        port = 8086,
                    },
                }
            end,
        },
    },
    config = function()
        local dap = require("dap")
        dap.adapters["pwa-node"] = {
            type = "server",
            host = "127.0.0.1",
            port = "${port}",
            executable = {
                command = "node",
                args = { require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                .. "/js-debug/src/dapDebugServer.js",
                    "${port}" },
            }
        }

        dap.configurations["typescript"] = {
            {
                type = "pwa-node",
                request = "launch",
                name = "Launch",
                autoAttachChildProcesses = true,
                skipFiles = { "<node_internals>/**", "**/node_modules/**" },
                program = "${workspaceFolder}/dist/${fileBasenameNoExtension}.js",
                cwd = "${workspaceFolder}",
                outFiles = { "${workspaceFolder}/dist/**/*.js" },
                sourceMaps = true,
                runtimeArgs = { "--nolazy", "--inspect-brk" },
                runtimeExecutable = "node",
                smartStep = true,
            },
            {
                type = "pwa-node",
                request = "launch",
                name = "Debug Current File (vitest)",
                autoAttachChildProcesses = true,
                skipFiles = { "<node_internals>/**", "**/node_modules/**" },
                program = "${workspaceRoot}/node_modules/vitest/vitest.mjs",
                args = { "run", "${relativeFile}" },
                smartStep = true,
                console = "integratedTerminal"
            }
        }

        dap.configurations["typescriptreact"] = dap.configurations["typescript"]

        dap.adapters["cppdbg"] = {
            type = "executable",
            id = "cppdbg",
            command = require("mason-registry").get_package("cpptools"):get_install_path() ..
                "/extension/debugAdapters/bin/OpenDebugAD7"
        }

        dap.configurations["c"] = {
            {
                name = "Launch file",
                type = "cppdbg",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopAtEntry = true,
            }
        }
        vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
    end,
    keys = {
        { "<F5>",       function() require("dap").continue() end,                                             { desc = "Continue execution" } },
        { "<F10>",      function() require("dap").step_over() end,                                            { desc = "Step over" } },
        { "<F11>",      function() require("dap").step_into() end,                                            { desc = "Step into" } },
        { "<F12>",      function() require("dap").step_out() end,                                             { desc = "Step out" } },
        { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
        { "<leader>db", function() require("dap").toggle_breakpoint() end,                                    desc = "Toggle Breakpoint" },
        { "<leader>da", function() require("dap").continue({ before = get_args }) end,                        desc = "Run with Args" },
        { "<leader>dC", function() require("dap").run_to_cursor() end,                                        desc = "Run to Cursor" },
        { "<leader>dg", function() require("dap").goto_() end,                                                desc = "Go to Line (No Execute)" },
        { "<leader>di", function() require("dap").step_into() end,                                            desc = "Step Into" },
        { "<leader>dj", function() require("dap").down() end,                                                 desc = "Down" },
        { "<leader>dk", function() require("dap").up() end,                                                   desc = "Up" },
        { "<leader>dl", function() require("dap").run_last() end,                                             desc = "Run Last" },
        { "<leader>do", function() require("dap").step_out() end,                                             desc = "Step Out" },
        { "<leader>dO", function() require("dap").step_over() end,                                            desc = "Step Over" },
        { "<leader>dp", function() require("dap").pause() end,                                                desc = "Pause" },
        { "<leader>dr", function() require("dap").repl.toggle() end,                                          desc = "Toggle REPL" },
        { "<leader>ds", function() require("dap").session() end,                                              desc = "Session" },
        { "<leader>dt", function() require("dap").terminate() end,                                            desc = "Terminate" },
        { "<leader>dw", function() require("dap.ui.widgets").hover() end,                                     desc = "Widgets" },
    },
}
