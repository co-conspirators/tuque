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
vim.api.nvim_create_autocmd({ 'BufEnter', 'ModeChanged' }, {
	callback = function()
		local mode = vim.api.nvim_get_mode().mode
		local mode_hl_group = mode_hl_groups[mode] or 'ModeNormal'
		local hl = vim.api.nvim_get_hl(0, { name = mode_hl_group, link = false })
		hl = vim.tbl_extend('force', { bold = true }, hl)
		vim.api.nvim_set_hl(0, 'CursorLineNr', hl)
	end,
})
