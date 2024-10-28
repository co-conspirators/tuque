local autocmd = vim.api.nvim_create_autocmd

-- Check if we need to reload the file when it changed
autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
	command = 'checktime',
})

-- Highlight on yank
autocmd('TextYankPost', {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- go to last loc when opening a buffer
autocmd('BufReadPost', {
	callback = function(event)
		local exclude = { 'gitcommit' }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
			return
		end
		vim.b[buf].lazyvim_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- close some filetypes with <q>
autocmd('FileType', {
	pattern = {
		'PlenaryTestPopup',
		'help',
		'lspinfo',
		'man',
		'notify',
		'qf',
		'query',
		'spectre_panel',
		'startuptime',
		'tsplayground',
		'neotest-output',
		'checkhealth',
		'neotest-summary',
		'neotest-output-panel',
		'toggleterm',
		'neo-tree',
		'gitsigns-blame',
		'AvanteAsk',
		'markdown',
	},
	callback = function(event)
		local bo = vim.bo[event.buf]
		if bo.filetype ~= 'markdown' or bo.buftype == 'help' then
			bo.buflisted = false
			vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
		end
	end,
})

local protected_filetypes = { 'blink-cmp', 'AvanteAsk', 'toggleterm' }
--- @type table<number, number>
local win_to_buf_map = {}
autocmd('BufWinEnter', {
	callback = function(event)
		local prev_buf = win_to_buf_map[event.win]
		if prev_buf == nil or not vim.api.nvim_buf_is_valid(prev_buf) then
			return
		end
		local bo = vim.bo[prev_buf]
		if not protected_filetypes[bo.filetype] then
			return
		end

		-- restore previous buffer
		vim.api.nvim_win_set_buf(event.win, prev_buf)

		-- pick a suitable window to display the buffer in
		local wins = vim.api.nvim_list_wins()
		local suitable_win = nil
		for _, win in ipairs(wins) do
			local bo = vim.bo[vim.api.nvim_win_get_buf(win)]
			if not protected_filetypes[bo.filetype] then
				suitable_win = win
				return
			end
		end

		-- create a new window, if there is no suitable window
		if suitable_win == nil then
			vim.api.nvim_command('vnew')
			suitable_win = vim.api.nvim_get_current_win()
		end

		-- set the buffer to the new window
		vim.api.nvim_win_set_buf(suitable_win, event.buf)
	end,
})
-- clear the win_to_buf_map when the window is closed
autocmd('WinLeave', {
	callback = function(event)
		win_to_buf_map[event.win] = nil
	end,
})

-- Sets the current line's color based on the current mode
-- Equivalent to modicator but fast
local mode_hl_groups = {
	[''] = 'ModeVisual',
	v = 'ModeVisual',
	V = 'ModeVisual',
	['\22'] = 'ModeVisual',
	n = 'ModeNormal',
	no = 'ModeNormal',
	i = 'ModeInsert',
	c = 'ModeCommand',
	s = 'ModeSelect',
	S = 'ModeSelect',
	R = 'ModeReplace',
	t = 'ModeTerminal',
	nt = 'ModeTerminal',
}
autocmd({ 'BufEnter', 'ModeChanged' }, {
	callback = function()
		local mode = vim.api.nvim_get_mode().mode
		local mode_hl_group = mode_hl_groups[mode]
		if mode_hl_group == nil then
			mode_hl_group = mode_hl_groups['n']
		end
		local hl = vim.api.nvim_get_hl(0, { name = mode_hl_groups[mode], link = false })
		hl = vim.tbl_extend('force', { bold = true }, hl)
		vim.api.nvim_set_hl(0, 'CursorLineNr', hl)
	end,
})
