local function apply(bufnr)
	local path = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
	if vim.bo[bufnr].buftype ~= "" or not vim.bo[bufnr].modifiable or path == "" then
		return
	end

	local config = {
		charset = "utf-8",
		end_of_line = "lf",
		indent_style = "tab",
		indent_size = 2,
		insert_final_newline = "true",
		max_line_length = 120,
		tab_width = 2,
		trim_trailing_whitespace = "true",
	}

	-- YAML
	if path:find("%.ya?ml$") then
		config.indent_style = "space"
	end

	local editorconfig = require("editorconfig")
	for k, v in pairs(config) do
		editorconfig.properties[k](bufnr, v, config)
	end

	config.root = "true"
	return config
end

local group = vim.api.nvim_create_augroup("AutoEditorConfig", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufFilePost" }, {
	group = group,
	callback = function(args)
		local opts = vim.b[args.buf]
		if not opts.editorconfig then
			opts.editorconfig = apply(args.buf)
		end
	end,
})
