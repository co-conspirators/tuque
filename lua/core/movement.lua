return {
	{
		'folke/flash.nvim',
		---@type Flash.Config
		opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x", "n" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
	},

	-- skip punctuation, subwords
	{
		'chrisgrieser/nvim-spider',
		keys = {
			{
				'w',
				"<cmd>lua require('spider').motion('w')<CR>",
				mode = { 'n', 'o', 'x' },
			},
			{
				'e',
				"<cmd>lua require('spider').motion('e')<CR>",
				mode = { 'n', 'o', 'x' },
			},
			{
				'b',
				"<cmd>lua require('spider').motion('b')<CR>",
				mode = { 'n', 'o', 'x' },
			},
		},
		opts = {
			subwordMovement = true,
		},
	},

	-- jump by edit locations
	{
		'bloznelis/before.nvim',
		event = 'BufRead',
		dependencies = { 'nvim-telescope/telescope.nvim' },
		keys = {
			{
				'<Backspace>',
				'``',
				desc = 'Jump to last edit location',
			},
			{
				'<S-Backspace>',
				function()
					require('before').jump_to_last_edit()
				end,
				desc = 'Jump to previous entry in the edit history',
			},
			{
				'<leader>fe',
				function()
					require('before').show_edits_in_telescope()
				end,
				desc = 'Edited buffers',
			},
		},
		config = true,
	},
}
