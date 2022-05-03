vim.cmd([[ let g:coc_global_extensions = [
    \ 'coc-css',
    \ 'coc-diagnostic',
    \ 'coc-emmet',
    \ 'coc-eslint',
    \ 'coc-git',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-pairs',
    \ 'coc-phpls',
    \ 'coc-php-cs-fixer',
    \ 'coc-sh',
    \ 'coc-snippets',
    \ 'coc-sql',
    \ 'coc-svg',
    \ 'https://github.com/rodrigore/coc-tailwind-intellisense',
    \ 'coc-tsserver',
    \ '@yaegassy/coc-volar',
    \ 'coc-r-lsp',
    \ 'coc-vimtex',
\ ]
]])

--Use tab for trigger completion with characters ahead and navigate.
--NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
--other plugin before putting this into your config.
vim.cmd([[ inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ Check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! Check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
]])

--Make <CR> auto-select the first completion item and notify coc.nvim to
--format on enter, <cr> could be remapped by other vim plugin
vim.cmd([[ inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>" ]])

--Use `[g` and `]g` to navigate diagnostics
--Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
vim.cmd([[ nmap <silent> [g <Plug>(coc-diagnostic-prev) ]])
vim.cmd([[ nmap <silent> ]g <Plug>(coc-diagnostic-next) ]])
vim.cmd([[ nmap <silent> <leader>d <Plug>(coc-diagnostic-info) ]])

--GoTo code navigation.
vim.cmd([[ nmap <silent> gd <Plug>(coc-definition) ]])
vim.cmd([[ nmap <silent> gy <Plug>(coc-type-definition) ]])
vim.cmd([[ nmap <silent> gi <Plug>(coc-implementation) ]])
vim.cmd([[ nmap <silent> gr <Plug>(coc-references) ]])

vim.cmd([[ nmap <silent> ]h <Plug>(coc-git-nextchunk) ]])
vim.cmd([[ nmap <silent> [h <Plug>(coc-git-prevchunk) ]])

--apply autofix to problem on the current line.
vim.cmd([[ nmap <leader>af  <plug>(coc-fix-current) ]])
vim.cmd([[ nmap <leader>am  <plug>(coc-format-selected) ]])
vim.cmd([[ xmap <leader>am  <plug>(coc-format-selected) ]])
vim.cmd([[ nmap <leader>ac  <Plug>(coc-codeaction) ]])
--Applying codeAction to the selected region.
--Example: `<leader>aap` for current paragraph
vim.cmd([[ xmap <leader>a  <Plug>(coc-codeaction-selected) ]])
vim.cmd([[ nmap <leader>a  <Plug>(coc-codeaction-selected) ]])
vim.cmd([[ nmap <leader>ga  <Plug>(coc-codeaction-line) ]])

--Map function and class text objects
--NOTE: Requires 'textDocument.documentSymbol' support from the language server.
vim.cmd([[ xmap if <Plug>(coc-funcobj-i) ]])
vim.cmd([[ omap if <Plug>(coc-funcobj-i) ]])
vim.cmd([[ xmap af <Plug>(coc-funcobj-a) ]])
vim.cmd([[ omap af <Plug>(coc-funcobj-a) ]])
vim.cmd([[ xmap ic <Plug>(coc-classobj-i) ]])
vim.cmd([[ omap ic <Plug>(coc-classobj-i) ]])
vim.cmd([[ xmap ac <Plug>(coc-classobj-a) ]])
vim.cmd([[ omap ac <Plug>(coc-classobj-a) ]])

--Use K to show documentation in preview window.
vim.cmd([[ nnoremap <silent> K :call Show_documentation()<CR>

function! Show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
 ]])
--Highlight the symbol and its references when holding the cursor.
vim.cmd([[ autocmd CursorHold * silent call CocActionAsync('highlight') ]])

--Symbol renaming.
vim.cmd([[ nmap <leader>rn <Plug>(coc-rename) ]])

--Remap <C-f> and <C-b> for scroll float windows/popups.
vim.cmd([[ nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>" ]])
vim.cmd([[ nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>" ]])
vim.cmd([[ inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>" ]])
vim.cmd([[ inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>" ]])
vim.cmd([[ vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>" ]])
vim.cmd([[ vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>" ]])
