return {
	{
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
