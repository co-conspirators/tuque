return {
	{
		'meznaric/key-analyzer.nvim',
		cmd = 'KeyAnalyzer',
		keys = {
			{
				'<leader>iK',
				function()
					vim.ui.input({ prompt = 'Mode to analyze ' }, function(mode)
						vim.ui.input({ prompt = 'Key to analyze: ' }, function(key)
							require('key-analyzer.main').show_keyboard_map(mode, key)
						end)
					end)
				end,
				desc = 'Key Analyzer',
			},
		},
		opts = { command_name = 'KeyAnalyzer' },
	},
}
