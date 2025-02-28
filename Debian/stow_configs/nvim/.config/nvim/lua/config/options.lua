-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.maplocalleader = ","
local opt = vim.opt
opt.wrap = true
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 4 -- Shift 4 spaces when tab
opt.tabstop = 4 -- 1 tab == 4 spaces
opt.smartindent = true -- Autoindent new lines
opt.mouse = "a" -- Enable mouse mode
opt.relativenumber = false -- Relative line numbers
opt.ruler = false -- Disable the default ruler
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.showmatch = true -- Highlight matching parenthesis
opt.foldmethod = "marker" -- Enable folding (default 'foldmarker')
opt.textwidth = 160
opt.colorcolumn = "160" -- Line lenght marker at 160 columns
vim.cmd([[ highlight ColorColumn ctermbg=red guibg=red ]]) -- but this does not
opt.splitright = true -- Vertical split to the right
