--buffer  line configurations
vim.cmd([[ let g:bufferline_fixed_index =  0 "always first ]])
vim.cmd([[ let g:bufferline_fixed_index =  1 "always second (default) ]])
vim.cmd([[ let g:bufferline_fixed_index = -1 "always last ]])
vim.cmd([[ let g:bufferline_modified = '+' ]])
vim.cmd([[ let g:bufferline_show_bufnr = 1 ]])
vim.cmd([[ let g:bufferline_active_buffer_left = '[' ]])
vim.cmd([[ let g:bufferline_active_buffer_right = '󰍟' ]])
vim.cmd([[ let g:bufferline_modified = '󰄴 ' ]])