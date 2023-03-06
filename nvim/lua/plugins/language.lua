return {
  {
    "simrat39/rust-tools.nvim",
    event = "BufRead",
    dependencies = {
      "mfussenegger/nvim-dap",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- For better debugging experience
      local dap_root = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/"
      local dap_adapter = require("rust-tools.dap").get_codelldb_adapter(
        dap_root .. "adapter/codelldb",
        dap_root .. "lldb/lib/liblldb.so"
      )
      require("dap").adapters.rust = dap_adapter

      local rt = require("rust-tools")
      rt.setup({
        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
          on_attach = function(_, bufnr)
            vim.keymap.set("n", "<C-Enter>", rt.hover_actions.hover_actions, { buffer = bufnr })
            -- vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
          end,
        },
        tools = {
          hover_actions = { auto_focus = true },
        },
        dap = { adapter = dap_adapter },
      })
    end
  }
}
