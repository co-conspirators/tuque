return {
	{
		'tuque/blink.nvim',
		lazy = false,
		dev = true,
		build = 'make',
		keys = {
			{
				';',
				function()
					require('blink.chartoggle').toggle_char_eol(';')
				end,
				mode = { 'n', 'v' },
				desc = 'Toggle ; at eol',
			},
			{
				',',
				function()
					require('blink.chartoggle').toggle_char_eol(',')
				end,
				mode = { 'n', 'v' },
				desc = 'Toggle , at eol',
			},
			{ '<C-e>', '<cmd>BlinkTree reveal<cr>', desc = 'Reveal current file in tree' },
			{ '<leader>E', '<cmd>BlinkTree toggle<cr>', desc = 'Reveal current file in tree' },
			{ '<leader>e', '<cmd>BlinkTree toggle-focus<cr>', desc = 'Toggle file tree focus' },
		},
		config = function()
			require('blink').setup()
		end,
	},
}
