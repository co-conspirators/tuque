return {
	'nvim-neo-tree/neo-tree.nvim',
	branch = 'v3.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-tree/nvim-web-devicons',
		'MunifTanjim/nui.nvim',
		{
			's1n7ax/nvim-window-picker',
			version = '2.*',
			config = function()
				require('window-picker').setup({
					filter_rules = {
						include_current_win = false,
						autoselect_one = true,
						-- filter using buffer options
						bo = {
							-- if the file type is one of following, the window will be ignored
							filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
							-- if the buffer type is one of following, the window will be ignored
							buftype = { 'terminal', 'quickfix' },
						},
					},
				})
			end,
		},
	},
	keys = {
		{ '<C-e>', '<cmd>Neotree reveal_force_cwd<cr>', desc = 'Reveal current file in tree' },
		{ '<leader>E', '<cmd>Neotree reveal_force_cwd<cr>', desc = 'Reveal current file in tree' },
		{
			'<leader>e',
			function()
				local is_neotree_focused = function()
					-- Get our current buffer number
					local bufnr = vim.api.nvim_get_current_buf and vim.api.nvim_get_current_buf() or vim.fn.bufnr()
					-- Get all the available sources in neo-tree
					for _, source in ipairs(require('neo-tree').config.sources) do
						-- Get each sources state
						local state = require('neo-tree.sources.manager').get_state(source)
						-- Check if the source has a state, if the state has a buffer and if the buffer is our current buffer
						if state and state.bufnr and state.bufnr == bufnr then
							return true
						end
					end
					return false
				end

				if is_neotree_focused() then
					vim.api.nvim_command('wincmd p')
				else
					vim.api.nvim_command('Neotree focus dir=.')
				end
			end,
			desc = 'Toggle file tree focus',
		},
	},
	-- show neo tree if we open in a directory
	init = function()
		if vim.fn.argc(-1) == 1 then
			local stat = vim.loop.fs_stat(vim.fn.argv(0))
			if stat and stat.type == 'directory' then
				require('neo-tree')
			end
		end
	end,
	config = function()
		local function hideCursor()
			vim.cmd([[
		      setlocal guicursor=n:block-Cursor
		      hi Cursor blend=100
		    ]])
		end
		local function showCursor()
			vim.cmd([[
		      setlocal guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
		      hi Cursor blend=0
		    ]])
		end

		local augroup = vim.api.nvim_create_augroup('NeoTreeCursor', {})
		vim.api.nvim_create_autocmd({ 'FileType' }, {
			pattern = 'neo-tree',
			callback = function()
				vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter', 'InsertEnter' }, {
					group = augroup,
					callback = function()
						if vim.bo.filetype == 'neo-tree' then
							hideCursor()
						else
							showCursor()
						end
					end,
				})
				vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave', 'InsertEnter' }, {
					group = augroup,
					callback = function()
						showCursor()
					end,
				})
			end,
		})

		require('neo-tree').setup({
			async_directory_scan = 'always',
			enable_diagnostics = false, -- todo: nukes perf
			sources = {
				'filesystem',
				'buffers',
				'git_status',
				-- 'document_symbols',
			},
			-- when opening a file, do not replace the current buffer in a window with one of these types
			open_files_do_not_replace_types = { 'terminal', 'trouble', 'edgy' },
			sort_case_insensitive = true,

			source_selector = {
				winbar = false,
			},
			default_component_configs = {
				indent = {
					indent_size = 2,
					padding = 1, -- extra padding on left hand side
					-- indent guides
					with_markers = true,
					indent_marker = '│',
					last_indent_marker = '└',
					-- expander config, needed for nesting files
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = '',
					expander_expanded = '',
					expander_highlight = 'NeoTreeExpander',
				},
				container = {
					enable_character_fade = false,
				},
				icon = {
					folder_closed = '',
					folder_open = '',
					folder_empty = '',
					folder_empty_open = '',
					-- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
					-- then these will never be used.
					default = '',
					highlight = 'NeoTreeFileIcon',
				},
				modified = {
					symbol = '●',
					highlight = 'NeoTreeModified',
				},
				git_status = {
					symbols = {
						-- Change type
						added = '', -- or "✚", but this is redundant info if you use git_status_colors on the name
						modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
						deleted = '󱎘', -- this can only be used in the git_status source
						renamed = '󰅂', -- this can only be used in the git_status source
						-- Status type
						untracked = '',
						ignored = '',
						unstaged = '󰄱',
						staged = '󰱒',
						conflict = '󰘬',
					},
				},
			},

			nesting_rules = {
				['package.json'] = {
					pattern = '^package%.json$',
					files = {
						'package-lock.json',
						'yarn*',
						'pnpm-lock.yaml',
						'biome.json',
						'.prettierrc',
						'.eslintrc*',
						'.lintstagedrc*',
						'bun.lockb',
					},
				},
				['go'] = {
					pattern = '(.*)%.go$',
					files = { '%1_test.go' },
				},
				['js-extended'] = {
					pattern = '(.+)%.js$',
					files = { '%1.js.map', '%1.min.js', '%1.d.ts', '%1.test.js', '%1.spec.js' },
				},
				['ts-extended'] = {
					pattern = '(.+)%.ts$',
					files = { '%1.ts.map', '%1.min.ts', '%1.test.ts', '%1.spec.ts' },
				},
				['tsconfig'] = {
					pattern = '^tsconfig%.json$',
					files = { '*.d.ts' },
				},
				['docker'] = {
					pattern = '^dockerfile$',
					ignore_case = true,
					files = { '.dockerignore', 'docker-compose.*', 'dockerfile*' },
				},
				['devenv'] = {
					pattern = '^devenv%.nix$',
					files = { 'devenv.lock', 'devenv.yaml', '.envrc' },
				},
			},
			filesystem = {
				-- results in dirs like a/b if a is empty
				-- doesnt work well without a cursor
				group_empty_dirs = false,
				use_libuv_file_watcher = true,
				follow_current_file = {
					enabled = false, -- todo: nukes perf
				},
				components = require('core.tree.filesystem'),
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_by_name = {
						'.git',
						'node_modules',
					},
					never_show = {
						'.git',
						'.DS_Store',
						'__pycache__',
						'.pytest_cache',
						'.classpath',
						'.project',
						'.settings',
						'.factorypath',
					},
					never_show_by_pattern = {
						'sublime-*',
					},
				},
				window = {
					mappings = {
						['<space>'] = 'none',
						['o'] = 'system_open',
						['f'] = 'fuzzy_finder',
						['F'] = 'filter_on_submit',
					},
				},
				commands = {
					system_open = function(state)
						local node = state.tree:get_node()
						local path = node:get_id()
						-- Linux: open file in default application
						vim.api.nvim_command(string.format("silent !xdg-open '%s'", path))
					end,
					-- Override delete to use trash instead of rm
					delete = function(state)
						local path = state.tree:get_node().path
						vim.fn.system({ 'trash', vim.fn.fnameescape(path) })
						require('neo-tree.sources.manager').refresh(state.name)
					end,
					-- over write default 'delete_visual' command to 'trash' x n.
					delete_visual = function(state, selected_nodes)
						local inputs = require('neo-tree.ui.inputs')

						-- get table items count
						function GetTableLen(tbl)
							local len = 0
							for _ in pairs(tbl) do
								len = len + 1
							end
							return len
						end

						local count = GetTableLen(selected_nodes)
						local msg = 'Are you sure you want to trash ' .. count .. ' files ?'
						inputs.confirm(msg, function(confirmed)
							if not confirmed then
								return
							end
							for _, node in ipairs(selected_nodes) do
								vim.fn.system({ 'trash', vim.fn.fnameescape(node.path) })
							end
							require('neo-tree.sources.manager').refresh(state.name)
						end)
					end,
				},
			},
			window = {
				width = 40,
				auto_expand_width = false,
				mappings = {
					['<space>'] = 'none',
					['<tab>'] = 'toggle_node',
					-- Hide git ignored
					['G'] = function(state)
						state.filtered_items.visible = false
						state.filtered_items.hide_gitignored = not state.filtered_items.hide_gitignored
						require('neo-tree.sources.manager').refresh('filesystem')
					end,
					-- Hide dotfiles
					['H'] = function(state)
						state.filtered_items.visible = false
						state.filtered_items.hide_dotfiles = not state.filtered_items.hide_dotfiles
						require('neo-tree.sources.manager').refresh('filesystem')
					end,
				},
			},
		})
	end,
}
