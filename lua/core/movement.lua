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

	-- overengineered harpoon
	-- TODO: come back to this
	-- {
	-- 	enabled = false,
	-- 	'dharmx/track.nvim',
	-- 	keys = {
	-- 		{ '<Enter><Enter>', '<cmd>Track<cr>', desc = 'Track' },
	-- 		{ '<Enter>b', '<cmd>Track branches<cr>', desc = 'Track branches' },
	-- 		{ '<Enter>m', '<cmd>Mark<cr>', desc = 'Mark' },
	-- 		{ '<Enter>M', '<cmd>Unmark<cr>', desc = 'Unmark' },
	-- 		{ '<leader>1', '<cmd>OpenMark 1<cr>', desc = 'OpenMark 1' },
	-- 		{ '<leader>2', '<cmd>OpenMark 2<cr>', desc = 'OpenMark 2' },
	-- 		{ '<leader>3', '<cmd>OpenMark 3<cr>', desc = 'OpenMark 3' },
	-- 		{ '<leader>4', '<cmd>OpenMark 4<cr>', desc = 'OpenMark 4' },
	-- 		{ '<leader>5', '<cmd>OpenMark 5<cr>', desc = 'OpenMark 5' },
	-- 		{ '<leader>6', '<cmd>OpenMark 6<cr>', desc = 'OpenMark 6' },
	-- 		{ '<leader>7', '<cmd>OpenMark 7<cr>', desc = 'OpenMark 7' },
	-- 		{ '<leader>8', '<cmd>OpenMark 8<cr>', desc = 'OpenMark 8' },
	-- 		{ '<leader>9', '<cmd>OpenMark 9<cr>', desc = 'OpenMark 9' },
	-- 	},
	-- 	opts = {},
	-- },
}
