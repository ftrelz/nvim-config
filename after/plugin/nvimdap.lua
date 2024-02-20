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

vim.keymap.set('n', '<F5>', function() require('dap').continue() end, { desc = "Continue execution" })
vim.keymap.set('n', '<F10>', function() require('dap').step_over() end, { desc = "Step over" })
vim.keymap.set('n', '<F11>', function() require('dap').step_into() end, { desc = "Step into" })
vim.keymap.set('n', '<F12>', function() require('dap').step_out() end, { desc = "Step out" })
vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end, { desc = "Toggle breakpoint" })
vim.keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end, { desc = "Set breakpoint" })
vim.keymap.set('n', '<Leader>lp', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "Set log point" })
vim.keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end, { desc = "Open REPL" })
vim.keymap.set('n', '<Leader>dl', function() require('dap').run_last() end, { desc = "Run last" })
vim.keymap.set({'n', 'v'}, '<Leader>dh', function()
    require('dap.ui.widgets').hover()
end, { desc = "Open hover widget" })
vim.keymap.set({'n', 'v'}, '<Leader>dp', function()
    require('dap.ui.widgets').preview()
end, { desc = "Open preview widget" })
vim.keymap.set('n', '<Leader>df', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.frames)
end, { desc = "Open centered float widget" })
vim.keymap.set('n', '<Leader>ds', function()
    local widgets = require('dap.ui.widgets')
    widgets.centered_float(widgets.scopes)
end, { desc = "Open scope widget" })
vim.keymap.set('n', '<Leader>dt', function()
    require'dap'.terminate()
end, { desc = "Terminate current session"})
