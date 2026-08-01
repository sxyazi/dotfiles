return {
	{
		"mrcjkb/rustaceanvim",
		lazy = false,
		init = function()
			vim.g.rustaceanvim = {
				tools = {
					enable_clippy = false,
				},
				server = {
					default_settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								-- target = "aarch64-pc-windows-msvc",
							},
							check = {
								-- targets = { "aarch64-unknown-linux-gnu" },
							},
							procMacro = { enable = true },
							diagnostics = {
								disabled = { "inactive-code", "unlinked-file" },
							},
						},
					},
				},
			}
		end,
	},

	-- An extensible framework for interacting with tests within NeoVim
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-plenary",
		},
		keys = {
			{ "<leader>s", function() require("neotest").run.run() end },
			{ "<leader>S", function() require("neotest").output.open { enter = true } end },
		},
		config = function()
			require("neotest").setup {
				adapters = {
					require("neotest-plenary"),
					require("rustaceanvim.neotest"),
				},
			}
		end,
	},
}
