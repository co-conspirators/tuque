return {
	{
		'saghen/blink.cmp',
		-- version = 'v0.*',
		dev = true,
		-- note: requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		build = 'cargo build --release',
		lazy = false,
		-- optional: provides snippets for the snippet source
		dependencies = 'rafamadriz/friendly-snippets',
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		--- @diagnostic disable: missing-fields
		opts = {
			keymap = {
				['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
				['<C-e>'] = { 'cancel' },
				['<C-g>'] = { 'accept' },

				['<C-t>'] = { 'select_prev' },
				['<C-d>'] = { 'select_next' },
				['<C-p>'] = { 'select_prev' },
				['<C-n>'] = { 'select_next' },

				['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
				['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

				['<Tab>'] = { 'snippet_forward', 'fallback' },
				['<S-Tab>'] = { 'snippet_backward', 'fallback' },
			},
			appearance = {
				nerd_font_variant = 'normal',
				use_nvim_cmp_as_default = true,
			},
			sources = {
				default = { 'lsp', 'buffer', 'path' },
				-- default = { 'lsp', 'buffer', 'path', 'snippets' },
				-- default = { 'lsp', 'buffer', 'luasnip', 'path' },
				cmdline = {},
				providers = {
					snippets = {
						opts = {
							extended_filetypes = {
								lua = { 'typescript' },
							},
						},
					},
				},
			},

			snippets = {
				expand = function(snippet)
					require('luasnip').lsp_expand(snippet)
				end,
				active = function(filter)
					if filter and filter.direction then
						return require('luasnip').jumpable(filter.direction)
					end
					return require('luasnip').in_snippet()
				end,
				jump = function(direction)
					require('luasnip').jump(direction)
				end,
			},

			completion = {
				-- list = { selection = 'auto_insert' },
				accept = { auto_brackets = { enabled = true } },
				documentation = { auto_show = false },
				ghost_text = { enabled = false },
			},

			signature = { enabled = true },
		},
		opts_extend = { 'sources.default' },
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = { 'saghen/blink.cmp' },
		config = function(_, opts)
			local lspconfig = require('lspconfig')
			for server, config in pairs(opts.servers) do
				config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
				lspconfig[server].setup(config)
			end
		end,
	},

	{
		'saghen/blink.nvim',
		dev = true,
		lazy = false,
		keys = {
			-- chartoggle
			{
				';',
				function()
					require('blink.chartoggle').toggle_char_eol(';')
				end,
				mode = 'v',
				desc = 'Toggle ; at eol',
			},
			{
				'<C-;>',
				function()
					require('blink.chartoggle').toggle_char_eol(';')
				end,
				mode = { 'i', 'n' },
				desc = 'Toggle ; at eol',
			},
			{
				',',
				function()
					require('blink.chartoggle').toggle_char_eol(',')
				end,
				mode = { 'n', 'v' },
				desc = 'Toggle , at eol',
			},
			{
				'<C-,>',
				function()
					require('blink.chartoggle').toggle_char_eol(',')
				end,
				mode = 'i',
				desc = 'Toggle , at eol',
			},

			-- select
			{
				'<leader>mb',
				function()
					require('blink.select').show('buffers')
				end,
				desc = 'Select buffer',
			},
			{
				'<leader>md',
				function()
					require('blink.select').show('diagnostics')
				end,
				desc = 'Select diagnostic',
			},
			{
				'<leader>mc',
				function()
					require('blink.select').show('recent-commands')
				end,
				desc = 'Select recent commands',
			},
			{
				'<leader>ms',
				function()
					require('blink.select').show('symbols')
				end,
				desc = 'Select symbol',
			},
			{
				'<leader>my',
				function()
					require('blink.select').show('yank-history')
				end,
				desc = 'Select yank history',
			},
			{
				'<leader>m/',
				function()
					require('blink.select').show('recent-searches')
				end,
				desc = 'Select search',
			},
			{
				'<leader>ma',
				function()
					require('blink.select').show('code-actions')
				end,
				desc = 'Select code action',
			},
			{
				'<leader>mo',
				function()
					require('blink.select').show('smart-open')
				end,
				desc = 'Select code action',
			},

			-- tree
			{ '<leader>E', '<cmd>BlinkTree reveal<cr>', desc = 'Reveal current file in tree' },
			{ '<leader>e', '<cmd>BlinkTree toggle-focus<cr>', desc = 'Toggle file tree window or focus' },
		},
		opts = {
			chartoggle = { enabled = true },
			delimiters = {
				enabled = true,
			},
			select = {
				enabled = true,
				mapping = {
					selection = { 'm', 'n', 'e', 'i', 'a', 'r', 's', 't' },
				},
			},
			indent = {
				enabled = true,
				scope = {
					highlights = {
						'RainbowOrange',
						'RainbowPurple',
						'RainbowBlue',
					},
					underline = {
						highlights = {
							'RainbowOrangeUnderline',
							'RainbowPurpleUnderline',
							'RainbowBlueUnderline',
						},
					},
				},
			},
			tree = { enabled = true },
		},
	},
}
