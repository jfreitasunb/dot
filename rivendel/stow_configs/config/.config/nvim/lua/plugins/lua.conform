return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      format_on_save = {
        timeout_ms = 2000,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" }, -- usa ambos
        tex = { "latexindent" },
      },
      formatters = {
        ruff_fix = {
          command = "ruff",
          -- args = { "format", "check", "--fix", "--select", "I", "--stdin-filename", "$FILENAME", "-" },
          args = { "format", "-" },
          stdin = true,
          stop_after_first = true,
        },
        ruff_format = {
          command = "ruff",
          args = { "format", "--stdin-filename", "$FILENAME", "-" },
          stdin = true,
          stop_after_first = true,
        },
      },
    },
  },
}

-- return {
--   {
--     "stevearc/conform.nvim",
--     event = { "BufWritePre" },
--     cmd = { "ConformInfo" },
--     opts = {
--       format_on_save = {
--         timeout_ms = 2000,
--         lsp_fallback = true,
--       },
--       formatters_by_ft = {
--         python = {
--           exe = "ruff",
--           args = { "--fix", "--select", "I" }, -- organiza imports e aplica correções
--           stdin = true,
--           stop_after_first = true,
--         },
--         tex = {
--           exe = "latexindent",
--           stdin = true,
--           stop_after_first = true,
--         },
--       },
--       post_format = function(ft, success)
--         local msg = success and string.format(" %s formatted successfully", ft)
--                                or string.format(" %s formatting failed", ft)
--         local level = success and vim.log.levels.INFO or vim.log.levels.ERROR
--
--         vim.notify(msg, level, {
--           title = "Conform.nvim",
--           timeout = 1500,
--           icon = success and "" or "",
--         })
--       end,
--     },
--   },
-- }
