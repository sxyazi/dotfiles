-- leader key
vim.g.mapleader = " "
vim.keymap.set("", "<Space>", "<Nop>")

-- special keys
vim.keymap.set("n", ";", ":")
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

vim.keymap.set("c", "<C-u>", "<Up>")
vim.keymap.set("v", "<C-u>", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("c", "<C-e>", "<Down>")
vim.keymap.set("v", "<C-e>", ":m '>+1<CR>gv=gv", { silent = true })

-- word navigation keys
vim.keymap.set("", "h", "e")
vim.keymap.set("n", "W", "5w")
vim.keymap.set("n", "B", "5b")

-- insert mode keys
vim.keymap.set("", "k", "i")
vim.keymap.set("", "K", "I")
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
vim.keymap.set("x", "p", '"_dp')
vim.keymap.set("x", "P", '"_dP')

vim.keymap.set("", "Y", '"+y')
vim.keymap.set({ "n", "v" }, "x", '"_x')

vim.keymap.set("n", "dw", 'vb"_d')
vim.keymap.set("n", "cw", 'vb"_c')

-- search keys
vim.keymap.set({ "n", "v" }, "-", "n")
vim.keymap.set({ "n", "v" }, "=", "N")

-- tab management
vim.keymap.set({ "n", "v" }, "tt", ":tabe<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "tT", ":tab split<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "tn", ":-tabnext<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "ti", ":+tabnext<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "tN", ":-tabmove<CR>", { silent = true })
vim.keymap.set({ "n", "v" }, "tI", ":+tabmove<CR>", { silent = true })

-- other keys
vim.keymap.set("", "<C-S-M-s>", ":w<CR>", { silent = true })
vim.keymap.set("i", "<C-S-M-s>", "<Esc>:w<CR>a", { silent = true })

vim.keymap.set("", "<C-a>", "ggVG$")
vim.keymap.set({ "i", "v" }, "<C-a>", "<Esc>ggVG$")

vim.keymap.set("", "<C-r>", ":filetype detect<CR>", { silent = true })
vim.keymap.set("i", "<C-r>", "<Esc>:filetype detect<CR>a", { silent = true })

vim.keymap.set("", "<C-->", "<C-a>")
vim.keymap.set({ "i", "v" }, "<C-->", "<Esc><C-a>a")
vim.keymap.set("", "<C-=>", "<C-x>")
vim.keymap.set({ "i", "v" }, "<C-=>", "<Esc><C-x>a")
