return {
	-- console/scratchpad
	{
		'yarospace/lua-console.nvim',
		lazy = true,
		keys = { { '<leader>il', desc = 'Lua Console' } },
		opts = { mappings = { toggle = '<leader>il' } },
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
	{
		'folke/lazydev.nvim',
		ft = 'lua', -- only load on lua files
		opts = {
			--- @module 'lazydev'
			--- @type lazydev.Library.spec[]
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = 'luvit-meta/library', words = { 'vim%.uv' } },
			},
		},
	},
	-- {
	-- 	'saghen/blink.cmp',
	-- 	dependencies = { 'folke/lazydev.nvim' },
	-- 	opts = {
	-- 		sources = {
	-- 			completion = {
	-- 				enabled_providers = { 'lazydev' },
	-- 			},
	-- 			providers = {
	-- 				lsp = { fallback_for = { 'lazydev' } },
	-- 				lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink' },
	-- 			},
	-- 		},
	-- 	},
	-- },
	{ 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			table.insert(opts.servers.efm.filetypes, 'lua')
			opts.servers.efm.settings.languages.lua = { require('efmls-configs.formatters.stylua') }
			opts.servers.lua_ls = {}
		end,
	},
}
