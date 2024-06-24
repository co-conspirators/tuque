return {
	'nvimdev/dashboard-nvim',
	dependencies = { 'navarasu/onedark.nvim', 'nvim-tree/nvim-web-devicons' },
	opts = {
		theme = 'hyper',
		config = {
			week_header = {
				enable = true,
			},
			project = {
				action = 'NeovimProjectLoadDashboard ',
			},
			shortcut = {
				{
					desc = '  Update',
					group = 'Cyan',
					action = 'Lazy update',
					key = 'u',
				},
				{
					desc = '  Last Session',
					group = 'Blue',
					action = 'NeovimProjectLoadRecent',
					key = 'l',
				},
				{
					desc = '  Projects',
					group = 'Yellow',
					action = 'Telescope neovim-project discover',
					key = 'p',
				},
				{
					desc = '  Sessions',
					group = 'Red',
					action = 'Telescope neovim-project history',
					key = 's',
				},
				{
					desc = '󱁿  Config',
					group = 'Purple',
					action = 'NeovimProjectLoad ~/.config/nvim',
					key = 'c',
				},
			},
		},
	},
}
