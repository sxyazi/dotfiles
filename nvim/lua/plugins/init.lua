return {
  { "nvim-neorg/neorg",         ft = "norg",        config = true },
  { "dstein64/vim-startuptime", cmd = "StartupTime" },

  { "stevearc/dressing.nvim",   event = "VeryLazy" },

  {
    "monaqa/dial.nvim",
    keys = { "<C-a>", { "<C-x>", mode = "n" } },
  },
}
