return {
	-- project and session management
	{
		'coffebar/neovim-project',
		lazy = vim.fn.getcwd() == os.getenv('HOME'),
		dependencies = {
			'nvim-lua/plenary.nvim',
			'Shatur/neovim-session-manager',
			'nvim-telescope/telescope.nvim',
		},
		keys = {
			{ '<leader>fp', '<cmd>Telescope neovim-project discover<cr>', desc = 'Projects' },
			{ '<leader>fs', '<cmd>Telescope neovim-project history<cr>', desc = 'Sessions' },
		},
		init = function()
			-- The dashboard returns the full path of the project but the
			-- NeovimProjectLoad command expects the path to be the same as the one in the projects list
			-- so we need to replace the home directory with ~
			vim.api.nvim_create_user_command('NeovimProjectLoadDashboard', function(args)
				local cwd = args.args
				local home = os.getenv('HOME')
				if home == nil then
					return vim.cmd('NeovimProjectLoad ' .. cwd)
				end

				local project = cwd:gsub(home, '~')
				vim.cmd('NeovimProjectLoad ' .. project)
			end, { nargs = 1 })
			vim.opt.sessionoptions = { 'buffers', 'curdir', 'folds', 'globals', 'tabpages', 'winsize' }
		end,
		opts = {
			last_session_on_startup = false,
			projects = {
				-- projects
				'~/code/huggingface/*',
				'~/code/huggingface/tokenizers/*',
				'~/code/huggingface/spaces/*',
				'~/code/liqwid/*',
				'~/code/nvim/*',
				'~/code/oz/*',
				'~/code/personal/*',
				'~/code/superfishial/*',

				-- dotfiles
				'/etc/nixos',
				'~/.config/*',
			},
			session_manager_opts = {
				autosave_ignore_buftypes = { 'nowrite' },
			},
		},
	},
}
