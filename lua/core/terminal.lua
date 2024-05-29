MainTerminal = nil

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
				'<leader>t',
				function()
					if not MainTerminal:is_open() then
						MainTerminal:open(80, 'vertical')
					elseif not MainTerminal:is_focused() then
						MainTerminal:focus()
						vim.cmd('startinsert') -- switch to terminal mode
					else
						vim.cmd('wincmd p')
					end
				end,
				desc = 'Focus terminal',
			},
			{
				'<leader>T',
				function()
					if MainTerminal:is_open() then
						MainTerminal:close()
					else
						MainTerminal:open(100, 'vertical')
					end
				end,
				desc = 'Toggle terminal',
			},
		},
		config = function()
			require('toggleterm').setup({})

			MainTerminal = require('toggleterm.terminal').Terminal:new({
				auto_scroll = false,
				autochdir = true,
				-- HACK: solves an issue with barbecue.nvim displaying a window bar
				-- https://github.com/utilyre/barbecue.nvim/issues/92
				on_open = function(term)
					vim.defer_fn(function()
						vim.wo[term.window].winbar = ''
					end, 0)
				end,
			})

			local opts = { buffer = 0 }
			vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
			vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
			vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
			vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
			vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
			vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)

			-- We can use <esc><esc> to be able to use a single <esc> in the terminal Vi mode.
			-- vim.api.nvim_buf_set_keymap(0, "t", "<esc><esc>", [[<C-\><C-o>:ToggleTerm<CR>]], { noremap = true })
			-- or we can use a single escape
			-- https://github.com/akinsho/toggleterm.nvim/issues/365
			vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { noremap = true })
		end,
	},
}
