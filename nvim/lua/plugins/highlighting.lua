return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    dependencies = { "windwp/nvim-ts-autotag" },
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "bash",
          "c",
          "cmake",
          "comment",
          "cpp",
          "css",
          "dart",
          "diff",
          "dockerfile",
          "fish",
          "git_rebase",
          "gitattributes",
          "gitcommit",
          "gitignore",
          "go",
          "gomod",
          "gosum",
          "gowork",
          "graphql",
          "html",
          "ini",
          "java",
          "javascript",
          "json",
          "json5",
          "latex",
          "lua",
          "make",
          "markdown",
          "nix",
          "php",
          "pug",
          "python",
          "regex",
          "ruby",
          "rust",
          "scss",
          "smali",
          "sql",
          "svelte",
          "swift",
          "toml",
          "tsx",
          "typescript",
          "vim",
          "vue",
          "yaml",
          "zig",
        },
        highlight = { enable = true },
        indent = { enable = true },
        autotag = { enable = true },
      }
    end,
  },
}