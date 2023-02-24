return {
  { 
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy", 
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require('lualine').setup()
    end,
  },
}
