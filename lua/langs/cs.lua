return {
	{
		'seblj/roslyn.nvim',
		ft = 'cs',
		opts = {
			exe = 'Microsoft.CodeAnalysis.LanguageServer',
		},
	},

	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				csharp_ls = {},
			},
		},
	},
}
