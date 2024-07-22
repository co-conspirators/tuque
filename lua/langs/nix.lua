return {
	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'nix' })
			end
		end,
	},
	-- LSP/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			opts.servers.nil_ls = {}

			table.insert(opts.servers.efm.filetypes, 'nix')
			opts.servers.efm.settings.languages.nix = { require('efmls-configs.formatters.nixfmt') }
		end,
	},
}
