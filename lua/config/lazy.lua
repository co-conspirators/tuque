local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require('config.options')
require('config.autocmds')
require('lazy').setup({
	spec = {
		{ import = 'core' },
		{ import = 'langs' },
		{ import = 'custom' },
		{ import = 'profile' },
	},
	defaults = {
		lazy = false, -- whether to lazy load all plugins by default
		version = false, -- always use the latest git commit
	},
	rocks = {
		hererocks = false,
	},
	checker = { enabled = false, frequency = 60 * 60 * 24 * 7 }, -- automatically check for plugin updates every week
	performance = {
		rtp = {
			-- disable some rtp plugins
			disabled_plugins = {
				'gzip',
				'matchit',
				'matchparen',
				'netrwPlugin',
				'tarPlugin',
				'tohtml',
				'tutor',
				'zipPlugin',
			},
		},
	},
	-- don't reload when config changes because it doesn't really work anyway?
	change_detection = {
		enabled = false,
		-- notify = false,
	},
	-- any plugins with dev = true will attempt to load from this local path
	dev = {
		path = '~/code/nvim',
		fallback = true,
	},
})
require('config.keymaps')
