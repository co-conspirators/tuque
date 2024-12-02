-- TODO: startup profiling
return {
	enabled = os.getenv('NVIM_PROFILE') ~= nil,
	'folke/snacks.nvim',
	lazy = false,
	priority = 1000,
	opts = function()
		local Snacks = require('snacks')
		-- Toggle the profiler
		Snacks.toggle.profiler():map('<f1>')
		-- Toggle the profiler highlights
		Snacks.toggle.profiler_highlights():map('<f2>')

		return {
			profiler = {
				filter_mod = {
					default = false,
					['^blink.cmp%.'] = true,
					['^blink.cmp.completion.windows.render%.'] = false,
				},
			},
		}
	end,
}
