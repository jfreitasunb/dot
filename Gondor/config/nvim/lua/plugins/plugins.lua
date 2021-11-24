vim.cmd([[ packadd packer.nvim ]])

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'morhetz/gruvbox'
  use 'norcalli/nvim-colorizer.lua'
  use 'tpope/vim-surround'
  use 'windwp/nvim-autopairs'
  use 'kyazdani42/nvim-web-devicons'
  use 'mbbill/undotree'
  use {'lervag/vimtex', config = [[ require('plugins/vimtex') ]]}
  use 'xuhdev/vim-latex-live-preview'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
end)
