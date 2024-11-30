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
		ft = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
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
			opts.servers.vtsls = {}
			-- opts.servers.eslint = {}
			-- opts.servers.biome = {}

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
}
