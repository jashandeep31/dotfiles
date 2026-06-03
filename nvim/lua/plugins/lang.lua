return {
  {
    "mfussenegger/nvim-dap",
    lazy = true,
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<CR>", desc = "Toggle breakpoint" },
      { "<leader>dc", "<cmd>DapContinue<CR>", desc = "Continue" },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    lazy = true,
    opts = function()
      local null_ls = require("null-ls")
      return {
        sources = {
          null_ls.builtins.formatting.stylua,
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.gofumpt,
        },
      }
    end,
  },
}
