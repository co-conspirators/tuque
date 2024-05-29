return {
	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'rust' })
			end
		end,
	},

	-- LSP + code actions
	'mrcjkb/rustaceanvim',

	-- formatting
	{
		'stevearc/conform.nvim',
		opts = {
			formatters_by_ft = {
				rust = { 'rustfmt' },
			},
		},
	},
}
