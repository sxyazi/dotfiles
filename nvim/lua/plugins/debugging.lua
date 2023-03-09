return {
  -- Bridges `mason.nvim` with `nvim-dap` plugin
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
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

  -- DAP client for Neovim
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint)

      local listeners                         = require("dap").listeners
      listeners.after.event_initialized.dapui = function() require("dapui").open() end
      listeners.before.event_terminated.dapui = function() require("dapui").close() end
      listeners.before.event_exited.dapui     = function() require("dapui").close() end

      vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
      vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
      vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "ﳁ", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
      vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", numhl = "DapLogPoint" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", numhl = "DapStopped" })
    end
  },

  -- A UI for `nvim-dap`
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = true,
    opts = {
      mappings = {
        edit = "k",
        expand = { "<Tab>", "<2-LeftMouse>" },
        open = "<CR>",
        remove = "d",
        repl = "r",
        toggle = "t"
      },
    },
  },

  -- Show variable value on debugging
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-dap-virtual-text").setup {
        all_references = true,
      }
    end
  }
}
