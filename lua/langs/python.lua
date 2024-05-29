return {
	-- pick venv (supports all major managers)
	{
		'linux-cultist/venv-selector.nvim',
		cmd = 'VenvSelect',
		opts = {
			dap_enabled = false,
			name = {
				'venv',
				'.venv',
				'env',
				'.env',
			},
		},
		keys = { { '<leader>cv', '<cmd>:VenvSelect<cr>', desc = 'Select VirtualEnv' } },
	},
	-- formatting
	{
		'stevearc/conform.nvim',
		opts = {
			-- todo: add ruff
			formatters_by_ft = { ['python'] = { 'black' } },
		},
	},
	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'python', 'ninja' })
			end
		end,
	},
	-- LSP
	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				pyright = {},
				ruff_lsp = {},
			},
		},
	},
}
