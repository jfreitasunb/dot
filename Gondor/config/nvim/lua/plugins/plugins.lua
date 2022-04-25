local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd([[ packadd packer.nvim ]])

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'morhetz/gruvbox'
  use 'tpope/vim-fugitive'
  use 'mattn/emmet-vim'
  use 'tpope/vim-sensible'
  use {'preservim/nerdtree', config = [[ require('plugins/configs_plugins/nerdtree')]]}
  use 'norcalli/nvim-colorizer.lua'
  use 'tpope/vim-surround'
  use {'windwp/nvim-autopairs', config = [[ require('plugins/configs_plugins/autopairs') ]]}
  use {'kyazdani42/nvim-web-devicons', config = [[ require('plugins/configs_plugins/web_dev_icons') ]]}
  --use {'tamton-aquib/staline.nvim', config = [[ require('plugins/configs_plugins/barra_status') ]]}
  use 'mbbill/undotree'
  use {'lervag/vimtex', config = [[ require('plugins/configs_plugins/vimtex') ]]}
  use {'lukas-reineke/indent-blankline.nvim', config = [[ require('plugins/configs_plugins/linhas_identacao')]]}
  use 'xuhdev/vim-latex-live-preview'
  use {
      'vim-airline/vim-airline',
      requires = { {'vim-airline/vim-airline-themes'} },
      config = [[ require('plugins/configs_plugins/airline')]]
  }
  use {'bling/vim-bufferline', config = [[ require('plugins/configs_plugins/bufferline')]]}
  use {
      'neoclide/coc.nvim',
      requires = { {'antoinemadec/coc-fzf'} },
      config = [[ require('plugins/configs_plugins/coc') ]]
    }
  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = [[ require('plugins/configs_plugins/telescope') ]]
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
