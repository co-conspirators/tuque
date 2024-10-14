return {
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
}
