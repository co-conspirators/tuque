return {
	-- autocomplete
	{
		enabled = os.getenv('NVIM_DEV') == nil,
		'supermaven-inc/supermaven-nvim',
		event = 'InsertEnter',
		opts = {
			keymaps = {
				accept_suggestion = '<M-i>',
			},
			color = {
				-- TODO: use onedark.nvim
				suggestion_color = '#585b70',
			},
			log_level = 'off',
		},
	},

	-- chat with code
	{
		'yetone/avante.nvim',
		keys = {
			{ mode = { 'n', 'v' }, '<leader>aa', '<cmd>AvanteAsk<cr>', desc = 'Ask AI' },
			{ mode = { 'n', 'v' }, '<leader>ar', '<cmd>AvanteRefresh<cr>', desc = 'Refresh AI' },
			{ mode = { 'n', 'v' }, '<leader>af', '<cmd>AvanteFocus<cr>', desc = 'Focus AI' },
			{ mode = { 'n', 'v' }, '<leader>ad', '<cmd>AvanteDebug<cr>', desc = 'Debug AI' },
			{ mode = { 'n', 'v' }, '<leader>at', '<cmd>AvanteToggle<cr>', desc = 'Toggle AI' },
		},
		--- @module 'avante'
		---@class avante.Config
		opts = {
			claude = {
				api_key_name = { 'fish', '-c', 'echo $ANTHROPIC_API_KEY' },
			},
			system_prompt = [[
Act as an expert software developer.
Always use best practices when coding.
Respect and use existing conventions, libraries, etc that are already present in the code base.
Keep responses very brief and concise, including code and only explaining when asked.
]],
			windows = {
				input = {
					prefix = '> ',
				},
				sidebar_header = {
					rounded = false,
				},
				edit = {
					border = 'single',
				},
				ask = {
					border = 'single',
				},
			},
			hints = { enabled = false },
		},
		build = 'make',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'stevearc/dressing.nvim',
			'nvim-lua/plenary.nvim',
			'MunifTanjim/nui.nvim',
			--- Optional dependencies
			'nvim-tree/nvim-web-devicons',
			{
				'MeanderingProgrammer/render-markdown.nvim',
				opts = {
					file_types = { 'Avante' },
				},
				ft = { 'Avante' },
			},
		},
	},
}
