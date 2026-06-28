local map = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = " "

map({ "n", "v" }, "<leader>w", "<cmd>w<CR>", opts)
map({ "n", "v" }, "<leader>q", "<cmd>q<CR>", opts)
map("n", "<leader>e", "<cmd>Explore<CR>", opts)
map("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

map({ "n", "v" }, "jk", "<Esc>", opts)
map({ "n", "v" }, "kj", "<Esc>", opts)

map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

map("n", "<A-h>", "<C-w><", opts)
map("n", "<A-l>", "<C-w>>", opts)
map("n", "<A-j>", "<C-w>-", opts)
map("n", "<A-k>", "<C-w>+", opts)

map("v", "J", ":m '>+1<CR>gv=gv", opts)
map("v", "K", ":m '<-2<CR>gv=gv", opts)

map("n", "<leader>pv", vim.cmd.Ex, opts)
