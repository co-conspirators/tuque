return {
	{
		'lewis6991/gitsigns.nvim',
		lazy = false,
		keys = {
			{ '<leader>gs', '<cmd>Gitsigns stage_hunk<cr>', desc = 'Stage hunk' },
			{ '<leader>gu', '<cmd>Gitsigns undo_stage_hunk<cr>', desc = 'Undo stage hunk' },
			{ '<leader>gb', '<cmd>Gitsigns blame<cr>', desc = 'Blame' },
			{ '<leader>gd', '<cmd>Gitsigns diffthis<cr>', desc = 'Diff this' },
		},
		opts = {},
	},

	-- convert git branches/files to remote URLs
	{
		'linrongbin16/gitlinker.nvim',
		cmd = 'GitLink',
		keys = {
			{ '<leader>go', '<cmd>GitLink! default_branch<cr>', mode = { 'n', 'v' }, desc = 'Open in browser' },
			{ '<leader>gO', '<cmd>GitLink!', mode = { 'n', 'v' }, desc = 'Open file in browser' },
			{ '<leader>gyy', '<cmd>GitLink<cr>', mode = { 'n', 'v' }, desc = 'Copy file url' },
			{ '<leader>gyb', '<cmd>GitLink current_branch<cr>', mode = { 'n', 'v' }, desc = 'Copy branch url' },
			{ '<leader>gyr', '<cmd>GitLink default_branch<cr>', mode = { 'n', 'v' }, desc = 'Copy repo url' },
			{ '<leader>gB', '<cmd>GitLink! blame<cr>', mode = { 'n', 'v' }, desc = 'Open blame in browser' },
		},
		opts = {},
	},

	-- ephemerally open git repositories
	{
		'moyiz/git-dev.nvim',
		cmd = { 'GitDevOpen', 'GitDevToggleUI', 'GitDevRecents', 'GitDevCleanAll' },
		keys = {
			{
				'<leader>gt',
				function()
					local repo = vim.fn.input('Repository name / URI: ')
					if repo ~= '' then
						require('git-dev').open(repo)
					end
				end,
				desc = 'Open remote git repo temporarily',
			},
			{ '<leader>sgr', '<cmd>GitDevRecents<cr>', desc = 'Recent repositories' },
		},
		opts = {
			ephemeral = false, -- don't delete after neovim exits
			-- The actual `open` behavior.
			---@param dir string The path to the local repository.
			---@param repo_uri string The URI that was used to clone this repository.
			---@param selected_path? string A relative path to a file in this repository.
			opener = function(dir, repo_uri, selected_path)
				require('git-dev').ui:print('Opening ' .. repo_uri)

				-- open selected file, readme or fallback to directory
				if selected_path == nil then
					local files = vim.fn.glob(dir .. '/readme*', nil, true)
					if #files > 0 then
						vim.cmd('edit ' .. vim.fn.fnameescape(files[1]))
					else
						vim.cmd('edit ' .. dir)
					end
				else
					vim.cmd('edit ' .. dir .. '/' .. selected_path)
				end

				-- open blink tree
				vim.cmd('BlinkTree open silent')
			end,
			ui = {
				close_after_ms = 0, -- close UI immediately
			},
		},
		config = function(_, opts)
			require('git-dev').setup(opts)
			require('telescope').load_extension('git_dev')
		end,
	},

	-- telescope pickers
	{
		'aaronhallaert/advanced-git-search.nvim',
		cmd = 'AdvancedGitSearch',
		dependencies = {
			{
				'nvim-telescope/telescope.nvim',
				opts = {
					extensions = {
						advanced_git_search = {
							show_builtin_git_pickers = true, -- show builtin pickers for show_custom_functions
							browse_command = 'GitLink! rev={commit_hash}',
							diff_plugin = 'diffview',
						},
					},
				},
			},
			'sindrets/diffview.nvim',
			'linrongbin16/gitlinker.nvim',
		},
		keys = {
			{ '<leader>sgl', '<cmd>AdvancedGitSearch search_log_content<cr>', desc = 'Search log content (file)' },
			{ '<leader>sgL', '<cmd>AdvancedGitSearch search_log_content<cr>', desc = 'Search log content (repo)' },
			{ '<leader>sgdf', '<cmd>AdvancedGitSearch diff_commit_file<cr>', desc = 'Diff with commit (file)' },
			{ '<leader>sgdb', '<cmd>AdvancedGitSearch diff_commit_line', 'Diff with branch (file)' },
			{ '<leader>sgdl', '<cmd>AdvancedGitSearch diff_commit_line', 'Diff with commit (line)' },
			{ '<leader>sgb', '<cmd>AdvancedGitSearch changed_on_branch<cr>', desc = 'Changed on branch' },
			{ '<leader>sgc', '<cmd>AdvancedGitSearch checkout_reflog<cr>', desc = 'Checkout via reflog' },
			{ '<leader>sgg', '<cmd>AdvancedGitSearch show_custom_functions', desc = 'Pick a picker' },
		},
		config = function()
			require('telescope').load_extension('advanced_git_search')
		end,
	},

	-- main client
	{
		'NeogitOrg/neogit',
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
			'sindrets/diffview.nvim',
		},
		keys = {
			-- NOTE: use `b o` in neogit to open issue
			{ '<leader>gg', '<cmd>Neogit kind=replace<cr>', desc = 'Open Neogit' },
		},
		opts = {
			-- don't scope persisted settings on a per-project basis
			use_per_project_settings = false,
			-- the time after which an output console is shown for slow running commands
			console_timeout = 4000,

			commit_editor = {
				kind = 'split',
			},
			mappings = {
				commit_editor = {
					['<enter>'] = 'Submit',
					['<backspace>'] = 'Abort',
				},
			},
		},
	},
}
