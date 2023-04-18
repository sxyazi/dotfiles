local M = {
	mason_lsp = {
		-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
		"bashls",
		"clangd", -- C/C++
		"cmake",
		"cssls",
		"dockerls",
		"docker_compose_language_service",
		"emmet_ls",
		"gopls", -- Golang
		"html",
		"jsonls",
		"pyright",
		"quick_lint_js", -- JavaScript
		"texlab", -- LaTeX
		"lua_ls",
		"marksman", -- Markdown
		"rust_analyzer",
		"sqlls", -- SQL
		"taplo", -- TOML
		"tailwindcss",
		"tsserver", -- TypeScript
		"lemminx", -- XML
		"yamlls", -- YAML
	},
	mason_null = {
		-- Bash
		"shfmt", -- formatting

		-- GitHub Action
		"actionlint", -- linter

		-- Golang
		"revive", -- linter
		"goimports", -- formatter

		-- JavaScript
		"eslint_d", -- linter
		"prettierd", -- formatter

		-- Lua
		"stylua", -- formatter

		-- Python
		"ruff", -- linter
		"black", -- formatter
	},
}

function M.lsp_attached(client, bufnr)
	-- Format on save
	local version = nil
	local function on_formatted(err, result, ctx)
		if err ~= nil then
			require("vim.lsp.log").error(string.format("[%s] %d: %s", client.name, err.code, err.message))
			return
		end
		if result == nil or not vim.api.nvim_buf_is_loaded(ctx.bufnr) then
			return
		end
		if vim.api.nvim_buf_get_var(ctx.bufnr, "changedtick") ~= version then
			return
		end

		vim.lsp.util.apply_text_edits(result, ctx.bufnr, "utf-16")
		if vim.api.nvim_get_current_buf() == ctx.bufnr then
			vim.b.format_saving = true
			vim.cmd("update")
			vim.b.format_saving = false
		end
	end
	if client.supports_method("textDocument/formatting") then
		local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
		vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }
		vim.api.nvim_create_autocmd("BufWritePost", {
			group = group,
			buffer = bufnr,
			callback = function()
				if vim.b.format_saving then
					return
				end

				local params = vim.lsp.util.make_formatting_params()
				version = vim.api.nvim_buf_get_var(bufnr, "changedtick")
				client.request("textDocument/formatting", params, on_formatted, bufnr)
			end,
		})
	end
end

function M.lua_setup()
	require("lspconfig").lua_ls.setup {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				diagnostics = { globals = { "vim" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
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
	-- disable hint, which are covered by `ruff`
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
		on_attach = M.lsp_attached,
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
		on_attach = M.lsp_attached,
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
		on_attach = M.lsp_attached,
	}
end

function M.markdown_setup()
	require("lspconfig").marksman.setup {
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		on_attach = M.lsp_attached,
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
			nls.setup {
				on_attach = M.lsp_attached,
				sources = {
					-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
					-- Bash
					nls.builtins.formatting.shfmt,

					-- GitHub Action
					nls.builtins.diagnostics.actionlint,

					-- Golang
					nls.builtins.diagnostics.revive.with {
						args = {
							"-config",
							vim.fn.expand("$HOME/.config/rules/revive.toml"),
							"-formatter",
							"json",
							"./...",
						},
					},
					nls.builtins.formatting.goimports,

					-- JavaScript
					nls.builtins.code_actions.eslint_d,
					nls.builtins.diagnostics.eslint_d,
					nls.builtins.formatting.prettierd,

					-- Lua
					nls.builtins.formatting.stylua.with {
						args = require("null-ls.helpers").range_formatting_args_factory({
							"--config-path",
							vim.fn.expand("$HOME/.config/rules/stylua.toml"),
							"--stdin-filepath",
							"$FILENAME",
							"-",
						}, "--range-start", "--range-end", { row_offset = -1, col_offset = -1 }),
					},

					-- Python
					nls.builtins.diagnostics.ruff,
					nls.builtins.formatting.ruff,
					nls.builtins.formatting.black,
				},
			}
		end,
	},
}
