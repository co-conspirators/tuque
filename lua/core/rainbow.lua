return {
	enabled = os.getenv('NVIM_DEV') == nil,
	'HiPhish/rainbow-delimiters.nvim',
	opts = function()
		local rainbow_delimiters = require('rainbow-delimiters')
		return {
			strategy = {
				[''] = rainbow_delimiters.strategy['global'],
			},
			query = {
				[''] = 'rainbow-delimiters',
			},
			highlight = {
				'RainbowOrange',
				'RainbowPurple',
				'RainbowBlue',
			},
		}
	end,
	config = function(_, opts)
		require('rainbow-delimiters.setup').setup(opts)
	end,
}
