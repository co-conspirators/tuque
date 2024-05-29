return {
	{
		enabled = false,
		'nvim-telescope/telescope-fzf-native.nvim',
		dependencies = {
			'nvim-telescope/telescope.nvim',
		},
		build = 'make',
		config = function()
			require('telescope').load_extension('fzf')
		end,
	},
	{
		'nvim-telescope/telescope.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		keys = {
			{ '<leader><enter>', '<cmd>Telescope find_files<cr>', desc = 'Files' },
			{ '<leader>.', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>', desc = 'Buffers' },
			{ '<leader>:', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
			{ '<leader>/', '<cmd>Telescope live_grep<cr>', desc = 'Grep' },
			{ "<leader>'", '<cmd>Telescope registers<cr>', desc = 'Registers' },
			{ '<leader>y', '<cmd>Telescope lsp_document_symbols<cr>', desc = 'Goto Symbol' },
			{ '<leader>r', '<cmd>Telescope resume<cr>', desc = 'Resume last search' },
			{ '<leader><space>', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', desc = 'Goto Symbol (Workspace)' },

			-- find
			{ '<leader>ff', '<cmd>Telescope git_files<cr>', desc = 'Find Git Files' },
			{ '<leader>fr', '<cmd>Telescope oldfiles<cr>', desc = 'Recent' },
			{
				'<leader>fc',
				'<cmd>lua require("telescope.builtin").find_files({ cwd = "~/.config" })<cr>',
				desc = 'Find .config file',
			},
			{ '<leader>fg', "<cmd>lua require'telescope'.extensions.repo.list{}<cr>", desc = 'Git Repositories' },
			-- { '<leader>fR', Util.telescope('oldfiles', { cwd = vim.loop.cwd() }), desc = 'Recent (cwd)' },

			-- git
			{ '<leader>gc', '<cmd>Telescope git_commits<cr>', desc = 'commits' },
			{ '<leader>gs', '<cmd>Telescope git_status<cr>', desc = 'status' },

			-- search
			{ '<leader>sa', '<cmd>Telescope autocommands<cr>', desc = 'Auto Commands' },
			{ '<leader>sb', '<cmd>Telescope current_buffer_fuzzy_find<cr>', desc = 'Buffer' },
			{ '<leader>sc', '<cmd>Telescope command_history<cr>', desc = 'Command History' },
			{ '<leader>sC', '<cmd>Telescope commands<cr>', desc = 'Commands' },
			{ '<leader>sd', '<cmd>Telescope diagnostics bufnr=0<cr>', desc = 'Document diagnostics' },
			{ '<leader>sD', '<cmd>Telescope diagnostics<cr>', desc = 'Workspace diagnostics' },
			{ '<leader>sh', '<cmd>Telescope help_tags<cr>', desc = 'Help Pages' },
			{ '<leader>sH', '<cmd>Telescope highlights<cr>', desc = 'Search Highlight Groups' },
			{ '<leader>sk', '<cmd>Telescope keymaps<cr>', desc = 'Key Maps' },
			{ '<leader>sM', '<cmd>Telescope man_pages<cr>', desc = 'Man Pages' },
			{ '<leader>sm', '<cmd>Telescope marks<cr>', desc = 'Jump to Mark' },
			{ '<leader>so', '<cmd>Telescope vim_options<cr>', desc = 'Options' },
			{ '<leader>cl', '<cmd>Telescope filetypes<cr>', desc = 'Pick Language' },
		},
		opts = function()
			local actions = require('telescope.actions')
			return {
				lsp_dynamic_workspace_symbols = {},
				defaults = {
					prompt_prefix = ' ',
					selection_caret = ' ',
					-- todo: not working
					-- open files in the first window that is an actual file.
					-- use the current window if no other window is available.
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == '' then
								return win
							end
						end
						return 0
					end,
					file_ignore_patterns = { 'node_modules' },
					mappings = {
						i = {
							['<C-Down>'] = actions.cycle_history_next,
							['<C-Up>'] = actions.cycle_history_prev,
							['<C-f>'] = actions.preview_scrolling_down,
							['<C-b>'] = actions.preview_scrolling_up,
						},
						n = {
							['q'] = actions.close,
						},
					},
				},
			}
		end,
	},

	-- zoxide integration
	{
		'jvgrootveld/telescope-zoxide',
		keys = {
			{ '<leader>fz', "<cmd>lua require('telescope').extensions.zoxide.list()<cr>", desc = 'Z' },
		},
		config = function()
			require('telescope').load_extension('zoxide')
		end,
	},

	-- fuzzy search over all repos on the system
	{
		'cljoly/telescope-repo.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
		},
		keys = {
			{ '<leader>fg', "<cmd>lua require'telescope'.extensions.repo.list{}<cr>", desc = 'Git Repositories' },
		},
		config = function()
			require('telescope').load_extension('repo')
		end,
	},
}
