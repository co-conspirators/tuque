return {
	-- autocomplete for cargo.toml
	{
		'saecki/crates.nvim',
		dependencies = { 'saghen/blink.compat', opts = { impersonate_nvim_cmp = true } },
		tag = 'stable',
		opts = {
			completion = {
				crates = { enabled = true },
				cmp = { enabled = true },
			},
		},
	},
	{
		'saghen/blink.cmp',
		dependencies = 'saecki/crates.nvim',
		opts = {
			sources = {
				default = { 'crates' },
				providers = {
					crates = {
						name = 'crates',
						module = 'blink.compat.source',
						fallbacks = { 'lsp' },
					},
				},
			},
		},
	},

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
	{
		'mrcjkb/rustaceanvim',
		ft = 'rust',
		dependencies = { 'saghen/blink.cmp' },
		init = function()
			vim.g.rustaceanvim = {
				server = {
					capabilities = require('blink.cmp').get_lsp_capabilities(),
				},
			}
		end,
	},

	-- formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			table.insert(opts.servers.efm.filetypes, 'rust')
			opts.servers.efm.settings.languages.rust = { require('efmls-configs.formatters.rustfmt') }
		end,
	},
}
