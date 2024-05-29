return {
	-- formatting
	{
		'stevearc/conform.nvim',
		opts = {
			formatters_by_ft = {
				lua = { 'stylua' },
			},
		},
	},
	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, {
					'lua',
					'luadoc',
					'luap',
				})
			end
		end,
	},
	-- LSP
	{ 'folke/neodev.nvim', opts = {} },
	{
		'neovim/nvim-lspconfig',
		dependencies = { 'folke/neodev.nvim' },
		opts = function(_, opts)
			return vim.tbl_extend('force', opts, {
				servers = {
					lua_ls = { before_init = require('neodev.lsp').before_init },
				},
			})
		end,
	},
}
