return {
	{
		'Wansmer/treesj',
		keys = {
			{ 'gm', '<cmd>TSJToggle<cr>', desc = 'Toggle Block' },
			{ 'gj', '<cmd>TSJJoin<cr>', desc = 'Join Block' },
			{ 'gp', '<cmd>TSJSplit<cr>', desc = 'Split Block' },
		},
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		opts = { use_default_keymap = false, max_join_length = 1000 },
	},

	-- support comment strings for different treesitter node types (i.e. JSX)
	-- todo: too slow because uses treesitter
	-- { 'folke/ts-comments.nvim', opts = {} },

	-- find and replace across workspace
	{
		'nvim-pack/nvim-spectre',
		dependencies = { 'nvim-lua/plenary.nvim' },
		keys = {
			{ '<leader>H', '<cmd>lua require("spectre").toggle()<cr>', desc = 'Find and Replace (Workspace)' },
		},
		opts = {
			is_insert_mode = true, -- open in insert mode
			live_update = true, -- execute search query immediately
			lnum_for_results = false, -- show line number for search/replace results
			-- disable borders
			line_sep_start = '',
			result_padding = '',
			line_sep = '',
			-- invert colors
			highlight = {
				ui = 'Primary',
				filename = 'Primary',
				-- todo: change these in theme?
				search = 'DiffDelete',
				replace = 'DiffAdd',
			},
		},
	},

	-- todo: fork to support limitting filetypes via lua or contribute
	{ 'echasnovski/mini.cursorword', version = false, opts = {} },
	{ 'echasnovski/mini.pairs', version = false, opts = {} },
	{
		'echasnovski/mini.surround',
		version = '*',
		keys = {
			{ 'gsa', desc = 'Add surrounding', mode = { 'n', 'v' } },
			{ 'gsd', desc = 'Delete surrounding' },
			{ 'gsf', desc = 'Find right surrounding' },
			{ 'gsF', desc = 'Find left surrounding' },
			{ 'gsh', desc = 'Highlight surrounding' },
			{ 'gsr', desc = 'Replace surrounding' },
		},
		opts = {
			mappings = {
				add = 'gsa', -- Add surrounding in Normal and Visual modes
				delete = 'gsd', -- Delete surrounding
				find = 'gsf', -- Find surrounding (to the right)
				find_left = 'gsF', -- Find surrounding (to the left)
				highlight = 'gsh', -- Highlight surrounding
				replace = 'gsr', -- Replace surrounding
			},
		},
	},
	{
		'echasnovski/mini.bufremove',
		keys = {
			{
				'<leader>bd',
				function()
					local bd = require('mini.bufremove').delete
					if vim.bo.modified then
						local choice = vim.fn.confirm(('Save changes to %q?'):format(vim.fn.bufname()), '&Yes\n&No\n&Cancel')
						if choice == 1 then -- Yes
							vim.cmd.write()
							bd(0)
						elseif choice == 2 then -- No
							bd(0, true)
						end
					else
						bd(0)
					end
				end,
				desc = 'Delete Buffer',
			},
			{
				'<leader>bD',
				function()
					require('mini.bufremove').delete(0, true)
				end,
				desc = 'Delete Buffer (Force)',
			},
		},
	},
}
