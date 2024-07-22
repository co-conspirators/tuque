return {
	{
		'saghen/blink.nvim',
		dependencies = {
			{ 'garymjr/nvim-snippets', opts = { create_cmp_source = false } },
		},
		lazy = false,
		dev = true,
		cmd = 'BlinkTree',
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
		opts = {
			chartoggle = { enabled = true },
			cmp = { enabled = true },
			indent = { enabled = true },
			tree = { enabled = true },
		},
	},
}
