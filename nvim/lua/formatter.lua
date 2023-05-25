local M = {
	fmt = {},
	order = {
		["eslint"] = 1, -- Prettier run first
		["gopls"] = -1, -- gopls run first
	},
}

-- https://github.com/neovim/neovim/blob/189e21ae50efe14d8446db11aee6b50f8022d99f/runtime/lua/vim/lsp/util.lua#L336
function M.line_byte_from_position(lines, position, offset_encoding)
	-- LSP's line and characters are 0-indexed
	-- Vim's line and columns are 1-indexed
	local col = position.character
	-- When on the first character, we can ignore the difference between byte and
	-- character
	if col > 0 then
		local line = lines[position.line + 1]
		local ok, result = pcall(vim.lsp.util._str_byteindex_enc, line, col, offset_encoding)
		if ok then
			return result
		end
		return math.min(#line, col)
	end
	return col
end

function M.apply_text_edits(edits, lines, encoding, eol)
	-- Fix reversed range and indexing each edits
	local index = 0
	edits = vim.tbl_map(function(edit)
		index = index + 1
		edit._index = index

		local range = edit.range
		if range.start.line > range["end"].line then
			return edit
		elseif range.start.line ~= range["end"].line or range.start.character <= range["end"].character then
			return edit
		else
			local start = range.start
			range.start = range["end"]
			range["end"] = start
			return edit
		end
	end, edits)

	-- Sort edits
	table.sort(edits, function(a, b)
		if a.range.start.line ~= b.range.start.line then
			return a.range.start.line > b.range.start.line
		end
		if a.range.start.character ~= b.range.start.character then
			return a.range.start.character > b.range.start.character
		end
		if a._index ~= b._index then
			return a._index > b._index
		end
	end)

	-- Apply text edits
	local exceed_eol = false
	for _, edit in ipairs(edits) do
		local rs = edit.range.start.line + 1
		local re = edit.range["end"].line + 1
		local cs = M.line_byte_from_position(lines, edit.range.start, encoding)
		local ce = M.line_byte_from_position(lines, edit.range["end"], encoding)

		local new_text, _ = string.gsub(edit.newText, "\r\n?", "\n")
		local ta = vim.split(new_text, "\n", { plain = true })

		if rs > #lines then
			vim.list_extend(lines, ta)
		else
			local last_line_len = #lines[math.min(#lines, re)]
			if re > #lines then
				re = #lines
				ce = last_line_len
				exceed_eol = true
			else
				if ce > last_line_len and #new_text > 0 and string.sub(new_text, -1) == "\n" then
					table.remove(ta, #ta)
				end
				ce = math.min(last_line_len, ce)
			end

			if rs == re then
				lines[rs] = string.sub(lines[rs], 1, cs) .. ta[1] .. string.sub(lines[re], ce + 1)
			else
				lines[rs] = string.sub(lines[rs], 1, cs) .. ta[1]
				lines[re] = ta[#ta] .. string.sub(lines[re], ce + 1)
				for _ = rs + 1, re - 1 do
					table.remove(lines, rs + 1)
				end
				for i = 2, #ta - 1 do
					table.insert(lines, rs + i - 1, ta[i])
				end
			end
		end
	end

	-- Remove final line if needed
	if exceed_eol and eol and lines[#lines] == "" then
		table.remove(lines, #lines)
	end
end

function M.send_changes(bufnr, client, edits, lines)
	-- 0=None, 1=Full, 2=Incremental
	local kind = (function()
		local inc_sync = vim.F.if_nil(client.config.flags.allow_incremental_sync, true)
		local capability = vim.tbl_get(client.server_capabilities or {}, "textDocumentSync", "change")

		if not inc_sync and capability == 2 then
			return 1
		end
		return capability or 0
	end)()

	if kind == 2 then
		edits = vim.tbl_map(
			function(edit)
				return {
					text = edit.newText,
					range = edit.range,
					rangeLength = edit.rangeLength,
				}
			end,
			edits
		)
	elseif kind == 1 then
		edits = {
			{ text = table.concat(lines, require("utils").line_ending(bufnr)) },
		}
	else
		return kind
	end

	client.rpc.notify("textDocument/didChange", {
		textDocument = {
			uri = vim.uri_from_bufnr(bufnr),
			version = vim.lsp.util.buf_versions[bufnr],
		},
		contentChanges = edits,
	})
	return kind
end

function M.format(fmt, lines, req_inc)
	local bufnr = fmt.bufnr
	local client = vim.lsp.get_client_by_id(table.remove(fmt.queue, 1))
	if not client then
		return
	end

	local function next(success)
		fmt.req_id = nil

		if not success then
			vim.b[bufnr].format_tick = nil
		elseif not vim.tbl_isempty(fmt.queue) then
			M.format(fmt, lines, req_inc)
		else
			local utils = require("utils")
			if utils.list_equal(lines, utils.full_lines(bufnr)) then
				return
			end
			for _, edits in ipairs(fmt.applies) do
				vim.lsp.util.apply_text_edits(edits, bufnr, client.offset_encoding)
			end
			if vim.api.nvim_get_current_buf() == bufnr then
				vim.cmd("noautocmd :update")
			end
		end
	end

	local function on_formatted(err, result)
		if req_inc ~= fmt.req_inc then
			return
		end
		if not vim.api.nvim_buf_is_loaded(bufnr) then
			return
		end
		if vim.b[bufnr].format_tick ~= vim.b[bufnr].changedtick then
			return
		end

		if err then
			require("vim.lsp.log").error(string.format("[%s] %d: %s", client.name, err.code, err.message))
			return next(false)
		end
		if result then
			local option = vim.api.nvim_buf_get_option
			local eol = option(bufnr, "eol") or (option(bufnr, "fixeol") and not option(bufnr, "binary"))

			table.insert(fmt.applies, result)
			M.apply_text_edits(result, lines, client.offset_encoding, eol)
		end
		next(true)
	end

	for _, edits in ipairs(fmt.applies) do
		if M.send_changes(bufnr, client, edits, lines) ~= 2 then
			break -- If not needed for incremental sync
		end
	end
	local ok, req_id = client.rpc.request("textDocument/formatting", fmt.params, on_formatted)
	if ok then
		fmt.req_id = req_id
	end
end

function M.attach(client, bufnr)
	if not client.supports_method("textDocument/formatting") then
		return
	end

	if M.fmt[bufnr] == nil then
		M.fmt[bufnr] = {
			bufnr = bufnr,
			params = vim.lsp.util.make_formatting_params(),
			clients = {},
			applies = {},
			queue = {},
			req_id = nil,
			req_inc = 0,
		}
	end

	local fmt = M.fmt[bufnr]
	fmt.clients[client.id] = true

	local group = vim.api.nvim_create_augroup("LspFormatting", { clear = false })
	vim.api.nvim_clear_autocmds { group = group, buffer = bufnr }
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = group,
		buffer = bufnr,
		callback = function()
			local tick = vim.b.changedtick
			if vim.b.format_tick == tick then
				return
			else
				vim.b.format_tick = tick
			end

			fmt.applies = {}
			fmt.req_inc = fmt.req_inc + 1
			if fmt.req_id ~= nil then
				client.rpc.notify("$/cancelRequest", { id = fmt.req_id })
				fmt.req_id = nil
			end

			fmt.queue = {}
			for client_id in pairs(fmt.clients) do
				fmt.queue[#fmt.queue + 1] = client_id
			end
			table.sort(fmt.queue, function(a, b)
				a = vim.lsp.get_client_by_id(a).name
				b = vim.lsp.get_client_by_id(b).name
				return (M.order[a] or 0) < (M.order[b] or 0)
			end)

			M.format(fmt, require("utils").full_lines(bufnr), fmt.req_inc)
		end,
	})
end

local ignored = {
	["eslint:key-spacing"] = true,
	["eslint:@typescript-eslint/comma-dangle"] = true,
	["eslint:jsonc/key-spacing"] = true,
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(function(_, result, ctx, config)
	result.diagnostics = vim.tbl_filter(
		function(diagnostic) return not ignored[diagnostic.source .. ":" .. (diagnostic.code or "")] end,
		result.diagnostics
	)
	return vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
end, {})

return M
