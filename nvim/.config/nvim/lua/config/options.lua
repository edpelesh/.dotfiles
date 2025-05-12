local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = false
opt.autoindent = true
opt.smartindent = true

opt.wrap = true

opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true
opt.scrolloff = 8
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"

opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-")
opt.isfname:append("@-@")

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.list = true
opt.listchars = {
	tab = '→ ',
	space = '·',
	trail = '•',
	extends = '⟩',
	precedes = '⟨',
	nbsp = '␣',
}

opt.termguicolors = true
opt.updatetime = 50

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

