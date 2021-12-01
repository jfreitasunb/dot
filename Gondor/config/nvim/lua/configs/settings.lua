vim.cmd([[ set encoding=utf-8 ]])
vim.cmd([[ set fileencoding=utf-8 ]])
vim.cmd([[ set exrc ]])
vim.cmd([[ syn on ]])
vim.cmd([[ set guicursor= ]])
vim.cmd([[ set relativenumber ]])
vim.cmd([[ set nu ]])
vim.cmd([[ set nohlsearch ]])
vim.cmd([[ set hidden ]])
vim.cmd([[ set noerrorbells ]])
vim.cmd([[ set tabstop=4 ]])
vim.cmd([[ set softtabstop=4 ]])
vim.cmd([[ set shiftwidth=4 ]])
vim.cmd([[ set expandtab ]])
vim.cmd([[ set smartindent ]])
vim.cmd([[ set noswapfile ]])
vim.cmd([[ set nobackup ]])
vim.cmd([[ set undodir=~/.nvim/undodir ]])
vim.cmd([[ set undofile ]])
vim.cmd([[ set incsearch ]])
vim.cmd([[ set termguicolors ]])
vim.cmd([[ set scrolloff=8 ]])
--vim.cmd([[ set colorcolumn=80 ]])
vim.cmd([[ set signcolumn=yes ]])
vim.cmd([[ set mouse=a ]])
vim.cmd([[ set confirm ]])


vim.cmd([[ set bg=dark ]])
vim.cmd([[ set termguicolors ]])
vim.cmd([[ colorscheme gruvbox ]])

vim.cmd([[ let extension = expand('%:e') ]])

vim.cmd([[ set splitright ]])
vim.cmd([[ set splitbelow]])
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

vim.cmd([[
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
]])

vim.cmd([[
augroup JOTA
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END
]])
