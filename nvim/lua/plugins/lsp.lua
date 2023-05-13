local M = {
	mason_lsp = {
		-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
		"bashls",
		"clangd",
		"cmake",
		"cssls",
		"dockerls",
		"docker_compose_language_service",
		"eslint",
		"emmet_ls",
		"gopls", -- Golang
		"html",
		"jsonls",
		"pyright",
		"texlab", -- LaTeX
		"lua_ls",
		"marksman", -- Markdown
		"rust_analyzer",
		"sqlls",
		"taplo", -- TOML
		"tailwindcss",
		"tsserver", -- JS/TS
		"lemminx", -- XML
		"yamlls", -- YAML
	},
	mason_null = {
		-- Bash
		"shfmt", -- formatting

		-- FE
		"stylelint", -- linter
		"prettier", -- formatter

		-- GitHub Action
		"actionlint", -- linter

		-- Golang
		"revive", -- linter
		"goimports", -- formatter

		-- Lua
		"stylua", -- formatter

		-- Python
		"ruff", -- linter
		"black", -- formatter
	},
	configs = {
		stylua = {
			files = { "stylua.toml", ".stylua.toml" },
			default = vim.fn.expand("$HOME/.config/rules/stylua.toml"),
		},
		luacheck = {
			files = { ".luacheckrc" },
			default = vim.fn.expand("$HOME/.config/rules/.luacheckrc"),
		},
		prettier = {
			files = {
				".prettierrc",
				"prettier.config.js",
				".prettierrc.js",
				".prettierrc.json",
				".prettierrc.yaml",
				".prettierrc.yml",
			},
			default = vim.fn.expand("$HOME/.config/rules/prettier.config.js"),
		},
		stylelint = {
			files = {
				".stylelintrc",
				"stylelint.config.js",
				".stylelintrc.json",
				".stylelintrc.yaml",
				".stylelintrc.yml",
				".stylelintrc.js",
			},
			default = vim.fn.expand("$HOME/.config/rules/stylelint/stylelint.config.js"),
		},
		revive = {
			files = { "revive.toml" },
			default = vim.fn.expand("$HOME/.config/rules/revive.toml"),
		},
	},
	fmt = {},
}

function M.format(params, bufnr, req_inc)
	local fmt = M.fmt[bufnr]
	local task = fmt.queue[1]
	table.remove(fmt.queue, 1)

	local client = vim.lsp.get_client_by_id(task)
	if not client then
		return
	end

	local function next(success)
		fmt.request_id = nil
		if not success then
			vim.b[bufnr].format_processing = nil
		elseif not vim.tbl_isempty(fmt.queue) then
			M.format(params, bufnr, req_inc)
		elseif vim.api.nvim_get_current_buf() == bufnr then
			vim.cmd("update")
		end
	end

	local function on_formatted(err, result, ctx)
		if req_inc ~= fmt.req_inc then
			return
		end
		if not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
			return
		end
		if vim.b[bufnr].format_processing ~= vim.api.nvim_buf_get_var(ctx.bufnr, "changedtick") then
			return
		end

		if err then
			require("vim.lsp.log").error(string.format("[%s] %d: %s", client.name, err.code, err.message))
			return next(false)
		end
		if result then
			vim.lsp.util.apply_text_edits(result, ctx.bufnr, client.offset_encoding)
		end
		next(true)
	end

	local ok, req_id = client.request("textDocument/formatting", params, on_formatted, bufnr)
	if ok then
		fmt.request_id = req_id
	end
end

function M.lsp_attached(client, bufnr)
	if not client.supports_method("textDocument/formatting") then
		return
	end

	if M.fmt[bufnr] == nil then
		M.fmt[bufnr] = { clients = {}, queue = {}, req_id = nil, req_inc = 0 }
	end

	local fmt = M.fmt[bufnr]
	fmt.clients[client.id] = true

	local params = vim.lsp.util.make_formatting_params()
	local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
	vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		buffer = bufnr,
		callback = function()
			local tick = vim.api.nvim_buf_get_var(bufnr, "changedtick")
			if vim.b.format_processing == tick then
				return
			else
				vim.b.format_processing = tick
			end

			fmt.queue = {}
			fmt.req_inc = fmt.req_inc + 1
			if fmt.req_id ~= nil then
				client.cancel_request(fmt.req_id)
				fmt.req_id = nil
			end

			for client_id in pairs(fmt.clients) do
				table.insert(fmt.queue, client_id)
			end
			M.format(params, bufnr, fmt.req_inc)
		end,
	})
end

function M.resolve_config(type)
	local config = M.configs[type]
	local cache = {}

	local function glob(cwd, dir)
		for _, file in ipairs(config.files) do
			if vim.fn.filereadable(dir .. "/" .. file) == 1 then
				cache[cwd] = dir .. "/" .. file
				return true
			end
		end
	end

	return function()
		local cwd = vim.fn.getcwd()
		if cache[cwd] then
			return cache[cwd]
		end

		if glob(cwd, cwd) then
			return cache[cwd]
		end

		for dir in vim.fs.parents(cwd) do
			if glob(cwd, dir) then
				return cache[cwd]
			end
		end

		cache[cwd] = config.default
		return cache[cwd]
	end
end

function M.lua_setup()
	require("lspconfig").lua_ls.setup {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		settings = {
			Lua = {
				completion = { postfix = "." },
				diagnostics = {
					disable = { "lowercase-global" },
					globals = { "vim" },
				},
				format = { enable = false },
				workspace = {
					checkThirdParty = false,
					ignoreDir = { ".vscode", "node_modules" },
					library = vim.api.nvim_get_runtime_file("", true),
				},
				runtime = { version = "LuaJIT" },
				telemetry = { enable = false },
			},
		},
	}
end

function M.go_setup()
	require("lspconfig").gopls.setup {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	}
end

function M.fe_setup()
	require("lspconfig").tsserver.setup {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	}
	require("lspconfig").html.setup {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	}
	require("lspconfig").cssls.setup {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		settings = {
			css = { validate = false },
		},
	}

	local eslint_default = require("lspconfig.server_configurations.eslint").default_config
	local eslint_settings = { packageManager = "pnpm", useESLintClass = true }

	if not eslint_default.root_dir(vim.fn.getcwd()) then
		eslint_settings.experimental = { useFlatConfig = true }
		eslint_settings.options = { overrideConfigFile = vim.fn.expand("$HOME/.config/rules/eslint/eslint.config.cjs") }
	end
	require("lspconfig").eslint.setup {
		filetypes = {
			"json",
			"jsonc",
			"json5",
			"yaml",
			"yaml.docker-compose",
			"toml",
			unpack(eslint_default.filetypes),
		},
		root_dir = function(fname) return eslint_default.root_dir(fname) or vim.fs.dirname(fname) end,
		-- https://github.com/Microsoft/vscode-eslint#settings-options
		settings = eslint_settings,
		on_attach = function(client, bufnr)
			client.server_capabilities.documentFormattingProvider = true
			client.server_capabilities.documentRangeFormattingProvider = true
			M.lsp_attached(client, bufnr)
		end,
	}

	require("lspconfig").tailwindcss.setup {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	}
end

function M.rust_setup()
	local rt = require("rust-tools")
	rt.setup {
		server = {
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
			on_attach = function(client, bufnr)
				M.lsp_attached(client, bufnr)
				vim.keymap.set("n", "<C-CR>", rt.hover_actions.hover_actions, { buffer = bufnr })
			end,
		},
		tools = {
			hover_actions = { auto_focus = true },
		},
	}
end

function M.python_setup()
	-- disable hints, which are covered by `ruff`
	-- https://github.com/lkhphuc/dotfiles/blob/6de9bd6fd5526c337445dc40000ec1573d4e351e/nvim/lua/plugins/extras/python.lua#L9
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }

	require("lspconfig").pyright.setup {
		capabilities = capabilities,
		settings = {
			python = {
				analysis = {
					diagnosticSeverityOverrides = {
						-- https://microsoft.github.io/pyright/#/configuration?id=diagnostic-rule-defaults
						reportMissingImports = "error",
						reportUndefinedVariable = "none",
					},
					typeCheckingMode = "off",
				},
			},
		},
	}
end

function M.json_setup()
	require("lspconfig").jsonls.setup {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
				validate = { enable = true },
			},
		},
	}
end

function M.yaml_setup()
	require("lspconfig").yamlls.setup {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		settings = {
			yaml = {
				schemas = require("schemastore").yaml.schemas(),
			},
		},
	}
end

function M.toml_setup()
	require("lspconfig").taplo.setup {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	}
end

function M.markdown_setup()
	require("lspconfig").marksman.setup {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	}
end

return {
	-- Configurations for build-in LSP of nvim
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"williamboman/mason-lspconfig.nvim",
				opts = { ensure_installed = M.mason_lsp, automatic_installation = true },
			},
			{ "simrat39/rust-tools.nvim", lazy = true },
			{ "b0o/SchemaStore.nvim", lazy = true },
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
			M.lua_setup()
			M.go_setup()
			M.fe_setup()
			M.rust_setup()
			M.python_setup()
			M.json_setup()
			M.yaml_setup()
			M.toml_setup()
			M.markdown_setup()
		end,
	},

	-- Integrating non-LSPs like Prettier
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
			{
				"jayp0521/mason-null-ls.nvim",
				opts = { ensure_installed = M.mason_null, automatic_installation = true },
			},
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local nls = require("null-ls")

			local stylua_config = M.resolve_config("stylua")
			local luacheck_config = M.resolve_config("luacheck")
			local stylelint_config = M.resolve_config("stylelint")
			local prettier_config = M.resolve_config("prettier")
			local revive_config = M.resolve_config("revive")
			nls.setup {
				on_attach = M.lsp_attached,
				sources = {
					-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
					-- Bash
					nls.builtins.formatting.shfmt,

					-- FE
					nls.builtins.diagnostics.stylelint.with {
						extra_args = function() return { "-c", stylelint_config() } end,
					},
					nls.builtins.formatting.stylelint.with {
						extra_args = function() return { "-c", stylelint_config() } end,
					},
					nls.builtins.formatting.prettier.with {
						extra_args = function() return { "--config", prettier_config() } end,
					},

					-- GitHub Action
					nls.builtins.diagnostics.actionlint,

					-- Golang
					nls.builtins.code_actions.gomodifytags,
					nls.builtins.code_actions.impl,
					nls.builtins.diagnostics.revive.with {
						extra_args = function() return { "-config", revive_config() } end,
					},
					nls.builtins.formatting.goimports,

					-- Lua
					nls.builtins.diagnostics.luacheck.with {
						extra_args = { "--config", luacheck_config() },
					},
					nls.builtins.formatting.stylua.with {
						extra_args = function() return { "--config-path", stylua_config(), "--no-editorconfig" } end,
					},

					-- Python
					nls.builtins.diagnostics.ruff,
					nls.builtins.formatting.ruff,
					nls.builtins.formatting.black,

					-- Misc
					nls.builtins.code_actions.gitrebase,
					nls.builtins.code_actions.gitsigns,
				},
			}
		end,
	},
}
