--[[

Neovim init file
Maintainer: brainf+ck
Website: https://github.com/brainfucksec/neovim-lua

--]]

-- Import Lua modules
require('packer_init')
require('core/options')
require('core/autocmds')
require('core/keymaps')
require('core/colors')
require('core/statusline')
require('plugins/nvim-tree')
require('plugins/vimtex')
require('plugins/indent-blankline')
require('plugins/airline')
require('plugins/nvim-cmp')
require('plugins/nvim-lsp-installer')
require('plugins/nvim-lspconfig')
require('plugins/nvim-treesitter')
require('plugins/alpha-nvim')
require('plugins/comment')

