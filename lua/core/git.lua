return {
	{
		'lewis6991/gitsigns.nvim',
		opts = {},
	},

	-- client
	{
		'NeogitOrg/neogit',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
			'sindrets/diffview.nvim',
		},
		keys = {
			{ '<leader>gg', '<cmd>Neogit kind=replace<cr>', desc = 'Open Neogit' },
		},
		opts = {
			-- don't scope persisted settings on a per-project basis
			use_per_project_settings = false,
			-- the time after which an output console is shown for slow running commands
			console_timeout = 4000,
		},
	},

	-- github integration
	{
		'pwntester/octo.nvim',
		keys = {
			{ '<leader>ghi', '<cmd>Octo issue list<cr>', desc = 'GH Issues' },
			{ '<leader>ghp', '<cmd>Octo pr list<cr>', desc = 'GH PRs' },
		},
		opts = {
			default_to_projects_v2 = true,
		},
	},

	-- highlighting
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(
					opts.ensure_installed,
					{ 'git_config', 'git_rebase', 'gitattributes', 'gitcommit', 'gitignore' }
				)
			end
		end,
	},
}
