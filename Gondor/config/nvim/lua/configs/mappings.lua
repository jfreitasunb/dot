vim.cmd([[ let mapleader = "\<space>"]])

vim.cmd([[ nmap <leader>ve :edit ~/.config/nvim/lua/configs/settings.lua<cr> ]])
vim.cmd([[ nmap <leader>vc :edit ~/.config/nvim/coc-settings.json<cr> ]])
vim.cmd([[ nmap <leader>vr :source ~/.config/nvim/lua/configs/settings.lua<cr> ]])

-- Para Salvar com 'Ctrl + S' nos modos: Normal, Inserção e Visual
-- Precisa adicionar a linha: stty -ixon , ao seu ~/.bashrc
vim.cmd([[ nnoremap <C-s> :w<CR> ]])
vim.cmd([[ inoremap <C-s> <Esc>:w<CR>l ]])
vim.cmd([[ vnoremap <C-s> <Esc>:w<CR> ]])

-- Selecionar tudo com 'Ctrl + A'
vim.cmd([[ map <C-a> ggVG ]])

-- BASH - Auto preenche arquivos .sh que não existirem com a SheBang
vim.cmd([[ autocmd BufNewFile *.sh :call append(0, '#!/usr/bin/env bash') ]])

-- Para o VimTeX
vim.cmd([[ nmap <leader>ll <Plug>(vimtex-compile) ]])
vim.cmd([[ nmap <leader>lk <Plug>(vimtex-stop) ]])
vim.cmd([[ nmap <leader>lc <Plug>(vimtex-clean) ]])

--Reselect visual selection after indenting
vim.cmd([[ vnoremap < <gv ]])
vim.cmd([[ vnoremap > >gv ]])

--Maintain the cursor position when yanking a visual selection
--http://ddrscott.github.io/blog/2016/yank-without-jank/
vim.cmd([[ vnoremap y myy`y ]])
vim.cmd([[ vnoremap Y myY`y ]])

--When text is wrapped, move by terminal rows, not lines, unless a count is provided
vim.cmd([[ noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j') ]])
vim.cmd([[ noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k') ]])

--Paste replace visual selection without copying it
vim.cmd([[ vnoremap <leader>p "_dP ]])

--Make Y behave like the other capitals
vim.cmd([[ nnoremap Y y$ ]])

--Keep it centered
vim.cmd([[ nnoremap n nzzzv ]])
vim.cmd([[ nnoremap N Nzzzv ]])
vim.cmd([[ nnoremap J mzJ`z ]])
