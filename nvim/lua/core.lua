-- disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.timeoutlen = 500
vim.opt.ttimeoutlen = 10
vim.opt.lazyredraw = true

vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undo"
vim.opt.undofile = true

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 5
vim.opt.linebreak = true
vim.opt.showbreak = "↳"
vim.opt.virtualedit = "block"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.hlsearch = false

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

vim.opt.showmode = false
vim.opt.shortmess:append("I")
vim.opt.signcolumn = "yes"
vim.opt.termguicolors = true

-- Diagnostic
vim.opt.updatetime = 300
vim.cmd([[autocmd CursorHold * lua vim.diagnostic.open_float()]])

vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

vim.diagnostic.config({
  virtual_text = false,
  float = { header = '', prefix = '', focusable = false },
  update_in_insert = true,
  severity_sort = true,
})

-- Restore cursor position when opening a file
-- https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370
vim.api.nvim_create_autocmd("BufRead", {
  callback = function(opts)
    vim.api.nvim_create_autocmd("BufWinEnter", {
      once = true,
      buffer = opts.buf,
      callback = function()
        local ft = vim.bo[opts.buf].filetype
        local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
        if
            not (ft:match("commit") and ft:match("rebase"))
            and last_known_line > 1
            and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
        then
          vim.api.nvim_feedkeys('g`"', "x", false)
        end
      end,
    })
  end,
})
