vim.cmd([[ packadd packer.nvim ]])

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use 'morhetz/gruvbox'
  use 'norcalli/nvim-colorizer.lua'
  use 'tpope/vim-surround'
  use {'windwp/nvim-autopairs', config = [[ require('plugins/configs_plugins/autopairs') ]]}
  use {'kyazdani42/nvim-web-devicons', config = [[ require('plugins/configs_plugins/web_dev_icons') ]]}
  use {'tamton-aquib/staline.nvim', config = [[ require('plugins/configs_plugins/barra_status') ]]}
  use 'mbbill/undotree'
  use {'lervag/vimtex', config = [[ require('plugins/configs_plugins/vimtex') ]]}
  use 'xuhdev/vim-latex-live-preview'
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
end)
