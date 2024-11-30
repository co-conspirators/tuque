return {
	{
		'kristijanhusak/vim-dadbod-ui',
		dependencies = {
			{ 'tpope/vim-dadbod', lazy = true },
			{ 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
		},
		keys = {
			{ '<leader>is', '<cmd>DBUI<cr>', desc = 'SQL' },
		},
		cmd = {
			'DBUI',
			'DBUIToggle',
			'DBUIAddConnection',
			'DBUIFindBuffer',
		},
		init = function()
			-- Your DBUI configuration
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	{
		'saghen/blink.cmp',
		opts = {
			sources = {
				-- add vim-dadbod-completion to your completion providers
				completion = {
					enabled_providers = { 'dadbod' },
				},
				providers = {
					dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
				},
			},
		},
	},
}
