return {
	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'go', 'goctl', 'gomod', 'gosum', 'gotmpl', 'gowork' })
			end
		end,
	},

	-- LSP
	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				gopls = {},
			},
		},
	},
}
