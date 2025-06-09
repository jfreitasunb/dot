-- ~/.config/nvim/lua/custom/plugins/colorizer.lua
return {
  "norcalli/nvim-colorizer.lua",
  event = "BufReadPre",
  config = function()
    require("colorizer").setup({
      "*", -- Aplica em todos os arquivos

      -- Configurações harmônicas e discretas
      css = {
        rgb_fn = true, -- Ativa funções rgb()
        hsl_fn = true, -- Ativa funções hsl()
        names = false, -- Evita nomes de cores (muito chamativo)
        mode = "background", -- Usa cor como foreground (mais sutil)
      },

      html = {
        names = false,
        mode = "background",
      },

      lua = {
        names = false,
        mode = "background",
      },
    })

    -- Comando opcional para ativar manualmente
    vim.cmd("ColorizerAttachToBuffer")
  end,
}
