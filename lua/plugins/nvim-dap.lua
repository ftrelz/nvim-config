return {
  "mfussenegger/nvim-dap",
  keys = {
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      "Continue",
    },
    {
      "<F10>",
      function()
        require("dap").step_over()
      end,
      "Step Over",
    },
    {
      "<F11>",
      function()
        require("dap").step_into()
      end,
      "Step Into",
    },
    {
      "<F12>",
      function()
        require("dap").step_out()
      end,
      "Step Out",
    },
  },
}
