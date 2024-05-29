return {
	'stevearc/conform.nvim',
	lazy = false,
	keys = {
		{
			'<leader>cf',
			function()
				require('conform').format({ async = true, lsp_fallback = false })
			end,
			desc = 'Format',
			mode = { 'n', 'v' },
		},
		{
			'<leader>uf',
			function()
				if vim.g.disable_autoformat == nil then
					vim.g.disable_autoformat = true
				else
					vim.g.disable_autoformat = not vim.g.disable_autoformat
				end
			end,
			desc = 'Toggle format on save',
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
	opts = {
		async = true,
		format_after_save = function(bufnr)
			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { lsp_fallback = false }
		end,
		formatters_by_ft = {},
	},
}
