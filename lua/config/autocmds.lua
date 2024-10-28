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
