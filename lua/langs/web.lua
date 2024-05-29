-- uses biome when available, fallback to prettierd
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
		config = function()
			require('nvim-treesitter.configs').setup({
				autotag = {
					enable = true,
				},
			})
		end,
	},

	-- linting/formatting
	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				eslint = {},
				biome = {},
				svelte = {},
				-- fixme: had to include them here to make it work ???
				-- didn't work when putting in fp.lua
				purescriptls = {},
				hls = {},
			},
		},
	},
	{
		'stevearc/conform.nvim',
		opts = {
			formatters_by_ft = {
				javascript = choose_formatter,
				javascriptreact = choose_formatter,
				typescript = choose_formatter,
				typescriptreact = choose_formatter,
				vue = choose_formatter,
				css = choose_formatter,
				scss = choose_formatter,
				less = choose_formatter,
				html = choose_formatter,
				json = choose_formatter,
				jsonc = choose_formatter,
				yaml = choose_formatter,
				graphql = { 'prettierd' },
				handlebars = { 'prettierd' },
				svelte = { 'prettierd' },
			},
		},
	},

	-- LSP
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

	-- performs drastically better than tsserver because we can limit the number of entries
	-- todo: shows symbols from node_modules, mitigated via telescope
	{
		'yioneko/nvim-vtsls',
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
	{ 'dmmulroy/tsc.nvim', config = true },
}
