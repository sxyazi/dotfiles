local M = {
	mason_tools = {
		-- Lua
		"lua-language-server", -- language server
		"stylua", -- formatter
		"luacheck", -- linter

		-- Golang
		"gopls", -- language server
		"goimports", -- formatter
		"revive", -- linter

		-- Rust (managed by `rustup`)
		-- "rustfmt", -- formatter"
		-- "rust-analyzer", -- language server

		-- Python
		"pyright", -- language server
		"ruff", -- formatter

		-- Shell
		"bash-language-server", -- language server
		"shfmt", -- formatting

		-- FE
		"typescript-language-server", -- TypeScript language server
		"css-lsp", -- CSS language server
		"json-lsp", -- JSON language server
		"tailwindcss-language-server", -- Tailwind language server
		"prettier", -- formatter
		"eslint-lsp", -- linter
		"stylelint", -- linter

		-- XML
		"html-lsp", -- HTML language server
		"taplo", -- TOML language server
		"yaml-language-server", -- YAML language server
		"lemminx", -- XML language server

		-- Docker
		"dockerfile-language-server",
		"docker-compose-language-service",

		-- GitHub Action
		"actionlint", -- linter

		-- Misc
		"cspell", -- spell checker
		"marksman", -- Markdown language server
		"sqlls", -- SQL language server
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
		revive = {
			files = { "revive.toml" },
			default = vim.fn.expand("$HOME/.config/rules/revive.toml"),
		},
		rustfmt = {
			files = { "rustfmt.toml", ".rustfmt.toml" },
			default = vim.fn.expand("$HOME/.config/rules/rustfmt.toml"),
		},
		prettier = {
			files = {
				".prettierrc",
				".prettierrc.js",
				".prettierrc.json",
				".prettierrc.yaml",
				".prettierrc.yml",
				"prettier.config.js",
			},
			default = vim.fn.expand("$HOME/.config/rules/.prettierrc.json"),
		},
		stylelint = {
			files = {
				".stylelintrc",
				".stylelintrc.js",
				".stylelintrc.json",
				".stylelintrc.yaml",
				".stylelintrc.yml",
				"stylelint.config.js",
			},
			default = vim.fn.expand("$HOME/.config/rules/stylelint/stylelint.config.js"),
		},
	},
}

function M.capabilities(override)
	if not M._capabilities then
		M._capabilities = require("cmp_nvim_lsp").default_capabilities()
	end
	return override and vim.tbl_deep_extend("keep", M._capabilities, override) or M._capabilities
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

function M.nix_setup()
	if vim.fn.isdirectory("/nix") == 0 then
		return
	end
	require("lspconfig").nil_ls.setup {
		capabilities = M.capabilities(),
		settings = {
			["nil"] = {
				formatting = {
					command = { "nixpkgs-fmt" },
				},
			},
		},
	}
end

function M.lua_setup()
	require("lspconfig").lua_ls.setup {
		capabilities = M.capabilities(),
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
					-- library = vim.api.nvim_get_runtime_file("", true),
				},
				runtime = { version = "LuaJIT" },
				telemetry = { enable = false },
			},
		},
	}
end

function M.go_setup()
	require("lspconfig").gopls.setup {
		capabilities = M.capabilities(),
	}
end

function M.fe_setup()
	require("lspconfig").ts_ls.setup {
		capabilities = M.capabilities(),
	}
	require("lspconfig").html.setup {
		capabilities = M.capabilities(),
	}
	require("lspconfig").cssls.setup {
		capabilities = M.capabilities(),
		settings = {
			css = { validate = false },
		},
	}

	local eslint_default = require("lspconfig").eslint.config_def.default_config
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
		end,
	}

	require("lspconfig").tailwindcss.setup {
		capabilities = M.capabilities(),
	}
end

function M.rust_setup()
	require("lspconfig").rust_analyzer.setup {
		capabilities = M.capabilities(),
		cmd = vim.lsp.rpc.connect("/tmp/ra-mux.sock"),
		settings = {
			["rust-analyzer"] = {
				cargo = { allFeatures = true },
				procMacro = { enable = true },
				checkOnSave = { command = "clippy" },
				lspMux = {
					version = "1",
					method = "connect",
					server = "rust-analyzer",
				},
			},
		},
	}

	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "*/Cargo.toml",
		callback = function()
			for _, client in ipairs(vim.lsp.get_clients { name = "rust_analyzer" }) do
				client.request("rust-analyzer/reloadWorkspace", nil, function() end, 0)
			end
		end,
		group = vim.api.nvim_create_augroup("RustWorkspaceRefresh", { clear = true }),
	})
end

function M.python_setup()
	-- Disable hints, which are covered by `ruff`
	-- https://github.com/lkhphuc/dotfiles/blob/6de9bd6fd5526c337445dc40000ec1573d4e351e/nvim/lua/plugins/extras/python.lua#L9
	local capabilities = M.capabilities {
		textDocument = {
			publishDiagnostics = {
				tagSupport = { valueSet = { 2 } },
			},
		},
	}

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
		capabilities = M.capabilities(),
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
		capabilities = M.capabilities(),
		settings = {
			yaml = {
				schemas = require("schemastore").yaml.schemas(),
			},
		},
	}
end

function M.toml_setup()
	require("lspconfig").taplo.setup {
		capabilities = M.capabilities(),
	}
end

function M.markdown_setup()
	require("lspconfig").marksman.setup {
		capabilities = M.capabilities(),
	}
end

return {
	-- Configurations for build-in LSP of nvim
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				opts = { ensure_installed = M.mason_tools },
			},
			{ "b0o/SchemaStore.nvim", lazy = true },
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
			M.nix_setup()
			M.lua_setup()
			M.go_setup()
			M.fe_setup()
			M.rust_setup()
			M.python_setup()
			M.json_setup()
			M.yaml_setup()
			-- M.toml_setup()
			M.markdown_setup()

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(event)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[event.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = event.buf })
					vim.keymap.set({ "n", "v" }, "<C-CR>", vim.lsp.buf.code_action, { buffer = event.buf })

					-- Jump to next/previous diagnostic
					vim.keymap.set(
						"n",
						"[e",
						function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR } end,
						{ buffer = event.buf }
					)
					vim.keymap.set(
						"n",
						"]e",
						function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR } end,
						{ buffer = event.buf }
					)
				end,
			})
		end,
	},

	{
		"stevearc/conform.nvim",
		event = "BufWritePre",
		config = function()
			local conform = require("conform")
			local stylua_config = M.resolve_config("stylua")
			local rustfmt_config = M.resolve_config("rustfmt")
			local prettier_config = M.resolve_config("prettier")
			local stylelint_config = M.resolve_config("stylelint")

			conform.formatters.stylua = {
				prepend_args = function() return { "--config-path", stylua_config(), "--no-editorconfig" } end,
			}
			conform.formatters.rustfmt = {
				prepend_args = function() return { "--config-path", rustfmt_config() } end,
			}
			conform.formatters.prettier = {
				prepend_args = function() return { "--config", prettier_config() } end,
			}
			conform.formatters.stylelint = {
				prepend_args = function() return { "-c", stylelint_config(), "--stdin-filepath", "$FILENAME" } end,
			}

			require("conform").setup {
				formatters_by_ft = {
					-- Lua
					lua = { "stylua" },
					luau = { "stylua" },

					-- Golang
					go = { "goimports" },

					-- Rust
					rust = { "rustfmt" },

					-- Python
					python = { "ruff_format" },

					-- JavaScript
					-- javascript = { "prettier" },
					-- javascriptreact = { "prettier" },
					-- ["javascript.jsx"] = { "prettier" },
					-- typescript = { "prettier" },
					-- typescriptreact = { "prettier" },
					-- ["typescript.jsx"] = { "prettier" },

					-- JSON/XML
					json = { "prettier" },
					jsonc = { "prettier" },
					json5 = { "prettier" },
					yaml = { "prettier" },
					["yaml.docker-compose"] = { "prettier" },
					html = { "prettier" },

					-- Markdown
					markdown = { "prettier" },
					["markdown.mdx"] = { "prettier" },

					-- CSS
					css = { "prettier", "stylelint" },
					less = { "prettier", "stylelint" },
					scss = { "prettier", "stylelint" },
					sass = { "prettier", "stylelint" },
				},
				format_after_save = {
					lsp_fallback = true,
				},
				notify_on_error = false,
			}
		end,
	},

	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				lua = { "luacheck" },
				go = { "revive" },
				css = { "stylelint" },
				less = { "stylelint" },
				scss = { "stylelint" },
				sass = { "stylelint" },
				yaml = { "actionlint" },
			}

			lint.linters.luacheck.args = {
				"--config",
				M.resolve_config("luacheck"),
				"--formatter",
				"plain",
				"--codes",
				"--ranges",
				"-",
			}
			lint.linters.revive.args = { "-config", M.resolve_config("revive") }
			lint.linters.stylelint.args = {
				"-c",
				M.resolve_config("stylelint"),
				"-f",
				"json",
				"--stdin",
				"--stdin-filename",
				function() return vim.fn.expand("%:p") end,
			}

			vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
				group = vim.api.nvim_create_augroup("Linting", { clear = true }),
				callback = function() lint.try_lint() end,
			})
		end,
	},

	-- Integrating non-LSPs like Prettier
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", lazy = true },
			{
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				opts = { ensure_installed = M.mason_tools },
			},
			{ "davidmh/cspell.nvim", lazy = true },
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local nls = require("null-ls")
			local cspell = require("cspell")

			nls.setup {
				sources = {
					cspell.diagnostics.with {
						diagnostics_postprocess = function(diagnostic) diagnostic.severity = vim.diagnostic.severity.HINT end,
					},
					cspell.code_actions,

					nls.builtins.code_actions.gitrebase,
					nls.builtins.code_actions.gitsigns,
				},
			}
		end,
	},
}
