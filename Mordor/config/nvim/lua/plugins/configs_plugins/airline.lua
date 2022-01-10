--Airline Settings
vim.cmd([[ let g:airline#extensions#tabline#enabled = 1 ]])
vim.cmd([[ let g:airline#extensions#tabline#formatter = 'default' ]])
vim.cmd([[ let g:airline_powerline_fonts = 1 ]])
vim.cmd([[ let g:airline#extensions#default#section_truncate_width = {
      \ 'b': 90,
      \ 'x': 70,
      \ 'y': 90,
      \ 'z': 50,
      \ 'warning': 80,
      \ 'error': 80,
      \ }
]])