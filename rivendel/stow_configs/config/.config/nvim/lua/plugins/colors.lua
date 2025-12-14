return {
    {
        "folke/tokyonight.nvim",
        config = function()
            vim.cmd.colorscheme "tokyonight"
            vim.cmd('hi Directory guibg=NONE')
            vim.cmd('hi SignColumn guibg=NONE')
        end
    },
}
