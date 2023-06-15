local M = {
	mason_dap = {
		-- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua#L6
		"delve", -- Go
		"codelldb", -- C/C++/Rust
		-- "js",
		"node2",
		"python",
	},
}

function M.go_setup()
	require("dap").adapters.delve = {
		type = "server",
		port = "${port}",
		executable = {
			command = "dlv",
			args = { "dap", "-l", "127.0.0.1:${port}" },
		},
	}
	require("dap").configurations.go = {
		{
			name = "Debug",
			type = "delve",
			request = "launch",
			program = "${file}",
		},
		{
			name = "Debug test",
			type = "delve",
			request = "launch",
			mode = "test",
			program = "${file}",
		},
		{
			name = "Debug test (go.mod)",
			type = "delve",
			request = "launch",
			mode = "test",
			program = "./${relativeFileDirname}",
		},
		{
			name = "Attach to process",
			type = "delve",
			request = "attach",
			mode = "local",
			processId = require("dap.utils").pick_process,
		},
	}
end

function M.rust_setup()
	local dap = require("dap")
	local dap_root = require("mason-registry").get_package("codelldb"):get_install_path() .. "/extension/"
	dap.adapters.codelldb = {
		type = "server",
		port = "${port}",
		host = "127.0.0.1",
		executable = {
			command = dap_root .. "adapter/codelldb",
			args = { "--liblldb", dap_root .. "lldb/lib/liblldb.dylib", "--port", "${port}" },
		},
	}

	dap.configurations.rust = {
		{
			name = "Debug",
			type = "codelldb",
			request = "launch",
			program = "${file}",
			cwd = "${workspaceFolder}",
			stopOnEntry = false,
		},
	}
	dap.configurations.c = dap.configurations.rust
	dap.configurations.cpp = dap.configurations.rust
end

function M.js_setup()
	local dap_root = require("mason-registry").get_package("node-debug2-adapter"):get_install_path()
	require("dap").adapters.node2 = {
		type = "executable",
		command = "node",
		args = { dap_root .. "/out/src/nodeDebug.js" },
	}
	require("dap").configurations.javascript = {
		{
			name = "Launch",
			type = "node2",
			request = "launch",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
		},
		{
			name = "Attach to process",
			type = "node2",
			request = "attach",
			processId = require("dap.utils").pick_process,
		},
	}
end

function M.python_setup()
	local dap_root = require("mason-registry").get_package("debugpy"):get_install_path()
	require("dap").adapters.python = {
		type = "executable",
		command = dap_root .. "/venv/bin/python",
		args = { "-m", "debugpy.adapter" },
	}
	require("dap").configurations.python = {
		{
			name = "Launch",
			type = "python",
			request = "launch",
			program = "${file}",
			pythonPath = function()
				local cwd = vim.fn.getcwd()
				if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
					return cwd .. "/venv/bin/python"
				elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
					return cwd .. "/.venv/bin/python"
				elseif vim.fn.executable("/opt/homebrew/bin/python3") == 1 then
					return "/opt/homebrew/bin/python3"
				elseif vim.fn.executable("/usr/local/bin/python3") == 1 then
					return "/usr/local/bin/python3"
				else
					return "/usr/bin/python"
				end
			end,
		},
	}
end

return {
	-- DAP client for Neovim
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{ "jay-babu/mason-nvim-dap.nvim", opts = { ensure_installed = M.mason_dap, automatic_installation = true } },
			{ "theHamsta/nvim-dap-virtual-text", opts = { all_references = true } },
		},
		keys = {
			{ "<leader>d", function() require("dap").continue() end },
			{ ",b", function() require("dap").toggle_breakpoint() end },
		},
		config = function()
			local listeners = require("dap").listeners
			listeners.after.event_initialized.dapui = function() require("dapui").open() end
			listeners.before.event_terminated.dapui = function() require("dapui").close() end
			listeners.before.event_exited.dapui = function() require("dapui").close() end

			vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
			vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
			vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

			vim.fn.sign_define("DapBreakpoint", { text = "󰝥", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "󰟃", texthl = "DapBreakpointCondition", numhl = "DapBreakpointCondition" }
			)
			vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DapBreakpoint", numhl = "DapBreakpoint" })
			vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DapLogPoint", numhl = "DapLogPoint" })
			vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", numhl = "DapStopped" })

			M.go_setup()
			M.rust_setup()
			M.js_setup()
			M.python_setup()
		end,
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
				toggle = "t",
			},
		},
	},
}
