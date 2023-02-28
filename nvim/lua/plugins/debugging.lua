return {
  {
    "mfussenegger/nvim-dap",
    event = "BufRead",
    config = function()

    end
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "BufRead",
    config = function()
      require("mason-nvim-dap").setup {
        ensure_installed = {
          -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua#L6
          "python",
          "cppdbg",
          "codelldb",
        },
        automatic_installation = true,
      }
    end
  },
}
