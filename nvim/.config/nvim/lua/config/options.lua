local opt = vim.opt

opt.number = true
opt.cursorline = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.list = true
opt.listchars = {
	tab = '→ ',
	space = '·',
	trail = '•',
	extends = '⟩',
	precedes = '⟨',
	nbsp = '␣',
}

opt.signcolumn = "yes"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

