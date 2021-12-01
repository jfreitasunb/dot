Plug 'lervag/vimtex'
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

"VimTeX commands
let g:tex_flavor = "latex"
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_method = 'zathura'

nmap <leader>ll <Plug>(vimtex-compile)
nmap <leader>lk <Plug>(vimtex-stop)
nmap <leader>lc <Plug>(vimtex-clean)