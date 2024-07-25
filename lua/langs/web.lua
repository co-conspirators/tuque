-- todo: uses biome when available, fallback to prettierd
local choose_formatter = function()
	local cwd = vim.fn.getcwd()
	local has_biome = vim.fn.filereadable(cwd .. '/biome.json')
	return has_biome == 1 and { 'biome' } or { 'prettierd' }
end

return {
	-- auto pairs for JSX
	{
		'windwp/nvim-ts-autotag',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		opts = {},
	},

	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, {
					'typescript',
					'tsx',
					'javascript',
					'purescript',
					'jsdoc',
					'css',
					'scss',
					'html',
				})
			end
		end,
	},

	-- linting/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			opts.servers.eslint = {}
			opts.servers.biome = {}
			opts.servers.svelte = {}

			-- formatting
			vim.list_extend(opts.servers.efm.filetypes, {
				'javascript',
				'javascriptreact',
				'typescript',
				'typescriptreact',
				'css',
				'scss',
				'less',
				'html',
				'json',
				'jsonc',
				'yaml',
				'graphql',
				'handlebars',
				'svelte',
			})
			local prettierd = require('efmls-configs.formatters.prettier_d')
			opts.servers.efm.settings.languages.javascript = { prettierd }
			opts.servers.efm.settings.languages.javascriptreact = { prettierd }
			opts.servers.efm.settings.languages.typescript = { prettierd }
			opts.servers.efm.settings.languages.typescriptreact = { prettierd }
			opts.servers.efm.settings.languages.css = { prettierd }
			opts.servers.efm.settings.languages.scss = { prettierd }
			opts.servers.efm.settings.languages.less = { prettierd }
			opts.servers.efm.settings.languages.html = { prettierd }
			opts.servers.efm.settings.languages.json = { prettierd }
			opts.servers.efm.settings.languages.jsonc = { prettierd }
			opts.servers.efm.settings.languages.yaml = { prettierd }
			opts.servers.efm.settings.languages.graphql = { prettierd }
			opts.servers.efm.settings.languages.handlebars = { prettierd }
			opts.servers.efm.settings.languages.svelte = { prettierd }
		end,
	},

	-- LSP

	-- performs drastically better than tsserver because we can limit the number of entries
	-- todo: shows symbols from node_modules, mitigated via telescope
	{
		'yioneko/nvim-vtsls',
		event = 'VeryLazy',
		config = function()
			local opts = require('vtsls').lspconfig
			opts.settings = {
				typescript = {
					preferences = {
						preferTypeOnlyAutoImports = true,
					},
					workspaceSymbols = {
						scope = 'currentProject',
						excludeLibrarySymbols = true,
					},
					tsserver = {
						pluginPaths = {
							-- requires: npm i -g @styled/typescript-styled-plugin typescript-styled-plugin
							-- TODO: Install with mason or some other way
							'~/.local/share/npm/lib/node_modules/@styled/typescript-styled-plugin',
						},
					},
				},
				vtsls = {
					autoUseWorkspaceTsdk = true,
					experimental = {
						completion = {
							-- enableServerSideFuzzyMatch = true,
							-- entriesLimit = 75,
						},
					},
				},
			}
			require('lspconfig').vtsls.setup(opts)
		end,
	},
	-- TODO: install with nix
	{ 'williamboman/mason.nvim', opts = { ensure_installed = { vtsls = {} } } },
	-- provides TSC command and diagnostics in editor
	{ 'dmmulroy/tsc.nvim', event = 'VeryLazy', config = true },
}
