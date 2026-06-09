-- OPTIONS
local set = vim.opt

set.termguicolors = true

set.wrap = true
set.encoding = "utf-8"
set.fileencoding = "utf-8"

-- line numbers
set.number = true
set.cursorline = true
set.relativenumber = true

-- indentation and tabs
set.tabstop = 4
set.shiftwidth = 4
set.autoindent = true
set.expandtab = true
set.smartindent = true

-- clipboard
set.clipboard:append("unnamedplus")

set.mouse = "a"

set.ruler = false
set.undofile = true
set.undolevels = 10000
set.updatetime = 200
set.showmatch = true
set.foldmethod = "marker"
set.textwidth = 160
set.colorcolumn = "160"
--vim.cmd([[ highlight ColorColumn ctermbg=red guibg=red ]])
set.splitright = true
