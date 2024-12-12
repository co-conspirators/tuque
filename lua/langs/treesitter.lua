return {
	'neovim/nvim-lspconfig',
	opts = {
		servers = {
			ts_query_ls = {
				settings = {
					parser_install_directories = {
						vim.fs.joinpath(vim.fn.stdpath('data'), '/lazy/nvim-treesitter/parser/'),
					},
				},
			},
		},
	},
}
