local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.wrap = false

opt.termguicolors = true

opt.hidden = true

opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("config") .. "/undo"
opt.undofile = true

opt.incsearch = true
opt.hlsearch = true

opt.scrolloff = 8
opt.sidescrolloff = 8

opt.updatetime = 300
opt.timeoutlen = 500

opt.signcolumn = "yes"

opt.clipboard = "unnamedplus"

opt.completeopt = { "menu", "menuone", "noselect" }

opt.mouse = "a"
