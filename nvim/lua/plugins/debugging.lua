return {
	-- An extensible framework for interacting with tests within NeoVim
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-plenary",
			"rouge8/neotest-rust",
		},
		keys = {
			{ "<leader>s", function() require("neotest").run.run() end },
			{ "<leader>S", function() require("neotest").output.open { enter = true } end },
		},
		config = function()
			require("neotest").setup {
				adapters = {
					require("neotest-plenary"),
					require("neotest-rust") {
						args = { "--no-capture" },
					},
				},
			}
		end,
	},
}
