-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set("", "<Space>", "<Nop>")

-- special keys
vim.keymap.set({ "n", "v" }, ";", ":")
vim.keymap.set("", "<Tab>", "<Nop>") -- Will be handled in `plugins/completion.lua`

-- reserved keys
vim.keymap.set("", "s", "<Nop>")
vim.keymap.set("", "S", "<Nop>")
vim.keymap.set("", "o", "<Nop>")
vim.keymap.set("", "O", "<Nop>")

-- up, down, left, right
vim.keymap.set("", "u", "k")
vim.keymap.set("", "U", "5k")
vim.keymap.set("", "e", "j")
vim.keymap.set("", "E", "5j")
vim.keymap.set("", "n", "h")
vim.keymap.set("", "N", "^")
vim.keymap.set("", "i", "l")
vim.keymap.set("", "I", "$")

vim.keymap.set("n", "<C-u>", 'line(".")>1 ? ":m .-2<CR>" : ""', { expr = true, silent = true })
vim.keymap.set("n", "<C-e>", 'line(".")<line("$") ? ":m .+1<CR>" : ""', { expr = true, silent = true })
vim.keymap.set("v", "<C-u>", 'line(".")>1 ? ":m \'<-2<CR>gv" : ""', { expr = true, silent = true })
vim.keymap.set("v", "<C-e>", 'line(".")<line("$") ? ":m \'>+1<CR>gv" : ""', { expr = true, silent = true })

vim.keymap.set("c", "<C-u>", "<Up>")
vim.keymap.set("c", "<C-e>", "<Down>")

-- word navigation keys
vim.keymap.set("", "h", "e")
vim.keymap.set("", "H", "E")

-- insert mode keys
vim.keymap.set("n", "k", function() return #vim.fn.getline(".") == 0 and '"_cc' or "i" end, { expr = true })
vim.keymap.set("v", "k", "i")
vim.keymap.set("v", "K", "I")
vim.keymap.set("", "m", "o")
vim.keymap.set("", "M", "O")

vim.keymap.set("n", "<C-n>", "I")
vim.keymap.set("i", "<C-n>", "<Esc>I")
vim.keymap.set("n", "<C-i>", "A")
vim.keymap.set("i", "<C-i>", "<Esc>A")

-- redo, undo
vim.keymap.set("n", "l", "u")
vim.keymap.set("n", "L", "<C-r>")

-- yank, paste
vim.keymap.set("x", "p", '"_dP')
vim.keymap.set("x", "P", '"_dp')

vim.keymap.set({ "n", "v" }, "x", '"_x')

vim.keymap.set("n", "dw", 'vb"_d')
vim.keymap.set("n", "cw", 'vb"_c')

-- search keys
vim.keymap.set("n", "-", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("x", "-", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("o", "-", "'Nn'[v:searchforward]", { expr = true })
vim.keymap.set("n", "=", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("x", "=", "'nN'[v:searchforward]", { expr = true })
vim.keymap.set("o", "=", "'nN'[v:searchforward]", { expr = true })

vim.keymap.set("v", "-", function() require("utils").search(false) end)
vim.keymap.set("v", "=", function() require("utils").search(true) end)

-- tab management
vim.keymap.set({ "n", "v" }, "tt", ":tabe<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "tT", ":tab split<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "tn", ":-tabnext<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "ti", ":+tabnext<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "tN", ":-tabmove<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "tI", ":+tabmove<CR>", { silent = true })

-- other keys
vim.keymap.set("n", "<C-S-M-s>", ":up<CR>", { silent = true })
vim.keymap.set("i", "<C-S-M-s>", "<Esc>:up<CR>a", { silent = true })
vim.keymap.set("v", "<C-S-M-s>", "<Esc>:up<CR>", { silent = true })

vim.keymap.set("", "<C-a>", "ggVG$")
vim.keymap.set({ "i", "v" }, "<C-a>", "<Esc>ggVG$")

vim.keymap.set("", "<C-r>", ":filetype detect<CR>", { silent = true })
vim.keymap.set("i", "<C-r>", "<Esc>:filetype detect<CR>a", { silent = true })

vim.keymap.set("", "<C-->", "<C-a>")
vim.keymap.set({ "i", "v" }, "<C-->", "<Esc><C-a>a")
vim.keymap.set("", "<C-=>", "<C-x>")
vim.keymap.set({ "i", "v" }, "<C-=>", "<Esc><C-x>a")

vim.keymap.set("n", "<leader>`", function() require("lazy").profile() end)
