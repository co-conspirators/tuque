-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt
local g = vim.g

g.mapleader = ' '
g.maplocalleader = '\\'

opt.completeopt = 'menu,menuone,preview'
opt.clipboard = ''

opt.conceallevel = 2 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs

opt.list = true -- Show some invisible characters (tabs...
opt.number = true -- Print line number
opt.pumblend = 0 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.shiftwidth = 2 -- Size of an indent
opt.showmode = false -- We have a status line and modicator
opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time
opt.ignorecase = true -- Ignore case when searching, unless there's a capital with flash.nvim
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { 'en' }
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = 'block' -- Allow cursor to move where there is no text in visual block mode
opt.wrap = true -- Line wrapping

-- folds
vim.o.foldcolumn = '0'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

-- don't show the neovim dashboard
opt.shortmess:append('I')

-- statusline
opt.cmdheight = 0
opt.laststatus = 0

-- Default splitting will cause your main splits to jump when opening an edgebar.
-- To prevent this, set `splitkeep` to either `screen` or `topline`.
opt.splitkeep = 'screen'

opt.list = true
opt.listchars:append('space:⋅')
opt.listchars:append('trail:⋅')
opt.fillchars = {
	fold = ' ', -- or "⸱"
	foldopen = '',
	foldclose = '',
	foldsep = ' ',
	diff = '╱',
	eob = ' ',

	vert = ' ',
	horiz = ' ',
	horizup = ' ',
	horizdown = ' ',
}

opt.mouse = 'a'
opt.mousemoveevent = true

opt.guifont = 'IosevkaCustom Nerd Font:h12'

-- Support for semantic higlighting https://github.com/neovim/neovim/pull/21100
g.lsp_semantic_enabled = 1

if g.neovide then
	opt.linespace = 4
	g.neovide_scale_factor = 1.0
	g.neovide_refresh_rate = 288
	g.neovide_cursor_trail_size = 0.1
	g.neovide_cursor_animation_length = 0.05
	g.neovide_scroll_animation_length = 0.1 -- 0.1 to enable, 0 to disable
	-- https://github.com/neovide/neovide/issues/1325#issuecomment-1281570219
	-- g.neovide_font_hinting = 'none'
	-- g.neovide_font_edging = 'subpixelantialias'
end

local query_parse = vim.treesitter.query.parse
local cache = {}

vim.treesitter.query.parse = function(lang, query)
	local hash = lang .. '-' .. vim.fn.sha256(query)
	if cache[hash] then
		return cache[hash]
	end
	local result = query_parse(lang, query)
	cache[hash] = result
	return result
end
