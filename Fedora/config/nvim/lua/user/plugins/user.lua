return {
  -- You can also add new plugins here as well:
  -- Add plugins, the lazy syntax
  -- "andweeb/presence.nvim",
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("lsp_signature").setup()
  --   end,
  -- },
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      vim.cmd([[ let g:tex_flavor = "latex"]])
      vim.cmd([[ let g:vimtex_quickfix_open_on_warning = 0]])
      vim.cmd([[ let g:vimtex_compiler_progname = 'nvr']])
      vim.cmd([[ let g:vimtex_view_method = 'zathura']])
      vim.cmd([[ let g:vimtex_quickfix_ignore_filters = [ 'Underfull', 'Overfull', 'specifier changed to',] ]])
    end,
  },
  "lukas-reineke/indent-blankline.nvim",
  event = "User AstroFile",
  config = function()
    vim.opt.listchars:append("space:⋅")
    vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
    vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]
    vim.cmd([[
        hi! MatchParen cterm=NONE,bold gui=NONE,bold guibg=NONE guifg=#FFFFFF
        let g:indentLine_fileTypeExclude = ['dashboard']
    ]])
    local status_ok, indent_blankline = pcall(require, 'indent_blankline')
    if not status_ok then
      return
    end

    indent_blankline.setup {
      char = "▏",
      use_treesitter = true,
      show_first_indent_level = false,
      filetype_exclude = {
        'help',
        'dashboard',
        'git',
        'markdown',
        'text',
        'terminal',
        'lspinfo',
        'packer',
        'NvimTree',
      },
      buftype_exclude = {
        'terminal',
        'nofile',
      },
      show_end_of_line = true,
      space_char_blankline = " ",
      char_highlight_list = {
        "IndentBlanklineIndent1",
        "IndentBlanklineIndent2",
        "IndentBlanklineIndent3",
        "IndentBlanklineIndent4",
        "IndentBlanklineIndent5",
        "IndentBlanklineIndent6",
      },
    }
  end,
  "ellisonleao/gruvbox.nvim",
  "navarasu/onedark.nvim",
}
