return {
	{
		'supermaven-inc/supermaven-nvim',
		opts = {
			keymaps = {
				accept_suggestion = '<M-i>',
			},
			color = {
				-- TODO: use onedark.nvim
				suggestion_color = '#585b70',
			},
			log_level = 'off',
		},
	},
	{
		enabled = false,
		'zbirenbaum/copilot.lua',
		build = ':Copilot auth',
		opts = {
			suggestion = {
				enabled = true,
				debounce = 50,
				auto_trigger = true,
				keymap = {
					accept = '<M-i>',
				},
			},
			panel = { enabled = false },
			filetypes = { yaml = true },
		},
	},
}
