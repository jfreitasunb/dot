local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd([[ packadd packer.nvim ]])

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

return require('packer').startup(function(use)
  use 'jalvesaq/Nvim-R'
  use 'wbthomason/packer.nvim'
  use 'morhetz/gruvbox'
  use 'tpope/vim-fugitive'
  use 'mattn/emmet-vim'
  use 'tpope/vim-sensible'
  -- use {'preservim/nerdtree', config = [[ require('plugins/configs_plugins/nerdtree')]]}
  use {'kyazdani42/nvim-tree.lua', config = [[ require('plugins/configs_plugins/treesitter') ]]}
  use "akinsho/bufferline.nvim"
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
--  use {
--      'neoclide/coc.nvim',
--      requires = { {'antoinemadec/coc-fzf'} },
--      config = [[ require('plugins/configs_plugins/coc') ]]
--    }
--
-- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"

  -- LSP
  use {'neovim/nvim-lspconfig', config = [[ require('plugins/lsp/init')]]} -- enable LSP
  use {'williamboman/nvim-lsp-installer', config = [[ require('plugins/lsp/lsp-installer') ]] } -- simple to use language server installer
  use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

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
