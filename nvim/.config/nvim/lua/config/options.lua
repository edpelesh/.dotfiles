local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = false
opt.autoindent = true

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")

opt.swapfile = false

opt.list = true
opt.listchars = {
	tab = '→ ',
	space = '·',
	trail = '•',
	extends = '⟩',
	precedes = '⟨',
	nbsp = '␣',
}

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

