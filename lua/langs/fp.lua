return {
	-- purescript syntax highlighting
	-- todo: why does treesitter not work?
	{ 'purescript-contrib/purescript-vim' },
	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'purescript', 'haskell' })
			end
		end,
	},
	-- LSP
	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				purescriptls = {},
				hls = {},
			},
		},
	},
}
