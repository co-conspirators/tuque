local is_zellij = os.getenv('ZELLIJ') ~= nil

local function update_zellij_tab_name()
	if is_zellij then
		vim.system({ 'zellij', 'action', 'rename-tab', vim.fn.getcwd() })
	end
end
update_zellij_tab_name()
vim.api.nvim_create_autocmd({ 'DirChanged' }, {
	callback = update_zellij_tab_name,
})

local function list_projects()
	local top_level_folders = {
		'~/code/liqwid/*',
		'~/code/nvim/*',
		'~/code/oz/*',
		'~/code/personal/*',
		'~/code/personal/keyboards/*',
		'~/code/superfishial/*',
	}
	local project_folders = {}
	for _, folder in ipairs(top_level_folders) do
		local child_folders = vim.fn.glob(folder, nil, true)
		vim.list_extend(project_folders, child_folders)
	end
	return project_folders
end

local function list_open_projects()
	if not is_zellij then
		return {}
	end
	local project_folders = vim.fn.system({ 'zellij', 'action', 'query-tab-names' })
	return vim.split(project_folders, '\n')
end

local function open_project(project_folder)
	-- in zellij, so focus or open new tab
	if is_zellij and vim.fn.getcwd() ~= os.getenv('HOME') then
		-- attempt to focus an existing tab
		local zellij_tab_cwds = vim.split(vim.fn.system({ 'zellij', 'action', 'query-tab-names' }), '\n')
		for tab_idx, tab_cwd in ipairs(zellij_tab_cwds) do
			if tab_cwd == project_folder then
				vim.fn.system({ 'zellij', 'action', 'go-to-tab', tostring(tab_idx) })
				return true
			end
		end

		-- otherwise, create a new tab
		vim.fn.system({ 'zellij', 'action', 'new-tab', '--cwd', project_folder, '--layout', 'neovim' })

		-- in terminal, regular switching behavior
	else
		vim.cmd('cd ' .. project_folder)
		vim.cmd('SessionManager load_current_dir_session')
	end
end

local function project_picker(show_opened_only)
	local project_folders = show_opened_only and list_open_projects() or list_projects()

	local pickers = require('telescope.pickers')
	local finders = require('telescope.finders')
	local conf = require('telescope.config').values
	local actions = require('telescope.actions')
	local action_state = require('telescope.actions.state')
	local entry_display = require('telescope.pickers.entry_display')

	local displayer = entry_display.create({
		separator = ' ',
		items = { { width = 30 }, { remaining = true } },
	})
	pickers
		.new({}, {
			prompt_title = 'Projects',
			finder = finders.new_table({
				results = project_folders,
				entry_maker = function(entry)
					local name = vim.fn.fnamemodify(entry, ':t')
					return {
						display = function(entry)
							return displayer({ entry.name, { entry.value, 'Comment' } })
						end,
						name = name,
						value = entry,
						ordinal = name .. ' ' .. entry,
					}
				end,
			}),
			-- todo: sort by last used
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local project_folder = action_state.get_selected_entry().value
					open_project(project_folder)
				end)
				return true
			end,
		})
		:find()
end

return {
	-- project and session management
	{
		'Shatur/neovim-session-manager',
		lazy = vim.fn.getcwd() == os.getenv('HOME'),
		dependencies = {
			'nvim-lua/plenary.nvim',
			'nvim-telescope/telescope.nvim',
		},
		cmd = { 'SessionManager', 'SessionManagerLoadDir' },
		keys = {
			{
				'<leader>a',
				function()
					project_picker(true)
				end,
				desc = 'Opened Projects',
			},
			{
				'<leader>A',
				function()
					project_picker(false)
				end,
				desc = 'Projects',
			},
			{ '<leader>fs', '<cmd>SessionManager load_session<cr>', desc = 'Sessions' },
			{ '<leader>fS', '<cmd>SessionManager delete_session<cr>', desc = 'Delete session' },
		},
		init = function()
			-- todo: open blink tree if it was previously open
			local sessions_group = vim.api.nvim_create_augroup('TuqueSessions', {})
			-- open blink tree (disabled in dev environment)
			if os.getenv('NVIM_DEV') == nil then
				vim.api.nvim_create_autocmd({ 'User' }, {
					pattern = 'SessionLoadPost',
					group = sessions_group,
					command = 'BlinkTree open silent',
				})
			end

			-- The dashboard returns the full path of the project but the
			-- NeovimProjectLoad command expects the path to be the same as the one in the projects list
			-- so we need to replace the home directory with ~
			vim.api.nvim_create_user_command('SessionManagerLoadDir', function(args)
				local cwd = vim.fn.expand(args.args)
				vim.cmd('cd ' .. cwd)
				vim.cmd('SessionManager load_current_dir_session')
			end, { nargs = 1 })
			vim.opt.sessionoptions = { 'buffers', 'curdir', 'folds', 'globals', 'tabpages', 'winsize' }

			-- Auto save session
			vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
				callback = function()
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						-- Don't save while there's any 'nofile' buffer open.
						if vim.api.nvim_get_option_value('buftype', { buf = buf }) == 'nofile' then
							return
						end
					end
					local start_time = vim.loop.hrtime()
					require('session_manager').save_current_session()
					local end_time = vim.loop.hrtime()
					print('Session saved in ' .. (end_time - start_time) / 1000000 .. ' ms')
				end,
			})
		end,
		config = function()
			local config = require('session_manager.config')
			require('session_manager').setup({
				autoload_mode = { config.AutoloadMode.GitSession, config.AutoloadMode.CurrentDir },
				autosave_ignore_buftypes = { 'nowrite' },
				autosave_ignore_filetypes = { 'blink-tree' },
			})
		end,
	},
}
