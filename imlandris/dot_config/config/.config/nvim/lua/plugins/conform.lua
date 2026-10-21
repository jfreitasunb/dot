return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			format_on_save = {
				timeout_ms = 2000,
				lsp_fallback = "fallback",
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
				latexindent = {
					-- Modifica os argumentos padrão do latexindent
					args = {
						"-m",
						"-y",
						[[
						defaultIndent: "    "
					        modifyLineBreaks:
					          textWrap:
					            columns: 120
						]],
						"-",
					},
				},
			},
		},
	},
}
