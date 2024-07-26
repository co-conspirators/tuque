--- @param mode string|string[] modes to map
--- @param lhs string lhs
--- @param rhs string rhs
local function map_blink_cmp(mode, lhs, rhs)
	return {
		lhs,
		function()
			local did_run = require('blink.cmp')[rhs]()
			if not did_run then
				return lhs
			end
		end,
		mode = mode,
		expr = true,
		noremap = true,
		silent = true,
		replace_keycodes = true,
	}
end

return {
	{
		'saghen/blink.nvim',
		dev = true,
		dependencies = {},
		lazy = false,
		cmd = 'BlinkTree',
		keys = {
			-- chartoggle
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

			-- tree
			{ '<C-e>', '<cmd>BlinkTree reveal<cr>', desc = 'Reveal current file in tree' },
			{ '<leader>E', '<cmd>BlinkTree toggle<cr>', desc = 'Reveal current file in tree' },
			{ '<leader>e', '<cmd>BlinkTree toggle-focus<cr>', desc = 'Toggle file tree focus' },
		},
		opts = {
			chartoggle = { enabled = true },
			cmp = { enabled = false },
			indent = { enabled = true },
			tree = { enabled = true },
		},
	},

	{
		'saghen/blink.cmp',
		event = 'InsertEnter',
		dependencies = {
			{
				'garymjr/nvim-snippets',
				dependencies = { 'rafamadriz/friendly-snippets' },
				opts = { create_cmp_source = false, friendly_snippets = true },
			},
		},
		dev = true,
		build = 'cargo build --release',
		keys = {
			map_blink_cmp('i', '<C-space>', 'show'),
			map_blink_cmp('i', '<Tab>', 'accept'),
			map_blink_cmp('i', '<Up>', 'select_prev'),
			map_blink_cmp('i', '<Down>', 'select_next'),
			map_blink_cmp('i', '<C-k>', 'select_prev'),
			map_blink_cmp('i', '<C-j>', 'select_next'),
		},
		config = function()
			require('blink.cmp').setup({})
		end,
	},
}
