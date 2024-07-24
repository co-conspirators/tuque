MainTerminal = nil

local toggle_term = function()
	if not MainTerminal:is_open() then
		MainTerminal:open()
	elseif not MainTerminal:is_focused() then
		MainTerminal:focus()
		vim.cmd('startinsert') -- switch to terminal mode
	else
		vim.cmd('wincmd p')
	end
end

return {
	-- nested neovim instances open in the parent
	{
		'willothy/flatten.nvim',
		lazy = false,
		priority = 1001,
		opts = { window = { open = 'smart' } },
	},

	-- terminal
	{
		'akinsho/nvim-toggleterm.lua',
		keys = {
			{
				[[<C-\>]],
				toggle_term,
				desc = 'Focus terminal',
			},
			{
				'<leader>t',
				toggle_term,
				desc = 'Focus terminal',
			},
		},
		opts = {
			autochdir = true,
			auto_scroll = false,
			shade_terminals = false,
			start_in_insert = true,
			insert_mappings = true,
			terminal_mappings = true,
			open_mapping = [[<C-\>]],

			-- HACK: solves an issue with barbecue.nvim displaying a window bar
			-- https://github.com/utilyre/barbecue.nvim/issues/92
			on_open = function(term)
				vim.defer_fn(function()
					vim.wo[term.window].winbar = ''
				end, 0)
			end,
		},
		config = function(_, opts)
			require('toggleterm').setup(opts)

			MainTerminal = require('toggleterm.terminal').Terminal:new()

			local mapOpts = {}
			vim.keymap.set('t', 'jk', [[<C-\><C-n>]], mapOpts)
			vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], mapOpts)
			vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], mapOpts)
			vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], mapOpts)
			vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], mapOpts)
			vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], mapOpts)

			-- We can use <esc><esc> to be able to use a single <esc> in the terminal Vi mode.
			-- vim.api.nvim_buf_set_keymap(0, "t", "<esc><esc>", [[<C-\><C-o>:ToggleTerm<CR>]], { noremap = true })
			-- or we can use a single escape
			-- https://github.com/akinsho/toggleterm.nvim/issues/365
			vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { noremap = true })
		end,
	},
}
