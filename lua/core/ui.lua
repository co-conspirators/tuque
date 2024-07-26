return {
	{
		'b0o/incline.nvim',
		event = 'VeryLazy',
		opts = {
			window = {
				padding = 0,
				margin = { horizontal = 0 },
			},
			render = function(props)
				local devicons = require('nvim-web-devicons')

				-- Filename
				local buf_path = vim.api.nvim_buf_get_name(props.buf)
				local dirname = vim.fn.fnamemodify(buf_path, ':~:.:h')
				local dirname_component = { dirname, group = 'Comment' }

				local filename = vim.fn.fnamemodify(buf_path, ':t')
				if filename == '' then
					filename = '[No Name]'
				end
				local diagnostic_level = nil
				for _, diagnostic in ipairs(vim.diagnostic.get(props.buf)) do
					diagnostic_level = math.min(diagnostic_level or 999, diagnostic.severity)
				end
				local filename_hl = diagnostic_level == vim.diagnostic.severity.HINT and 'DiagnosticHint'
					or diagnostic_level == vim.diagnostic.severity.INFO and 'DiagnosticInfo'
					or diagnostic_level == vim.diagnostic.severity.WARN and 'DiagnosticWarn'
					or diagnostic_level == vim.diagnostic.severity.ERROR and 'DiagnosticError'
					or 'Normal'
				local filename_component = { filename, group = filename_hl }

				-- Modified icon
				local modified = vim.bo[props.buf].modified
				local modified_component = modified and { ' ● ', group = 'BufferCurrentMod' } or ''

				local ft_icon, ft_color = devicons.get_icon_color(filename)
				local icon_component = ft_icon and { ' ', ft_icon, ' ', guifg = ft_color } or ''

				return {
					modified_component,
					icon_component,
					' ',
					filename_component,
					' ',
					dirname_component,
					' ',
				}
			end,
		},
	},

	-- folding
	{
		enabled = false,
		'kevinhwang91/nvim-ufo',
		dependencies = { 'kevinhwang91/promise-async' },
		opts = {
			-- dont fold by default
			close_fold_kinds_for_ft = { default = {} },
			-- use treesitter for finding folds
			provider_selector = function(_, _, _)
				return { 'treesitter', 'indent' }
			end,
			-- Adding number suffix of folded lines instead of the default ellipsis
			-- https://github.com/kevinhwang91/nvim-ufo?tab=readme-ov-file#customize-fold-text
			fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
				local newVirtText = {}
				local suffix = (' 󰁂 %d '):format(endLnum - lnum)
				local sufWidth = vim.fn.strdisplaywidth(suffix)
				local targetWidth = width - sufWidth
				local curWidth = 0
				for _, chunk in ipairs(virtText) do
					local chunkText = chunk[1]
					local chunkWidth = vim.fn.strdisplaywidth(chunkText)
					if targetWidth > curWidth + chunkWidth then
						table.insert(newVirtText, chunk)
					else
						chunkText = truncate(chunkText, targetWidth - curWidth)
						local hlGroup = chunk[2]
						table.insert(newVirtText, { chunkText, hlGroup })
						chunkWidth = vim.fn.strdisplaywidth(chunkText)
						-- str width returned from truncate() may less than 2nd argument, need padding
						if curWidth + chunkWidth < targetWidth then
							suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
						end
						break
					end
					curWidth = curWidth + chunkWidth
				end
				table.insert(newVirtText, { suffix, 'MoreMsg' })
				return newVirtText
			end,
		},
	},

	-- partition UI elements
	{
		'folke/edgy.nvim',
		event = 'VeryLazy',
		opts = {
			animate = { enabled = false },
			icons = {
				closed = '',
				open = '',
			},
			wo = { winbar = false },
			options = {
				left = { size = 40 },
				right = { size = 80 },
			},
			bottom = {
				'Trouble',
				{ ft = 'qf', title = 'QuickFix' },
				{
					ft = 'help',
					size = { height = 20 },
					-- only show help buffers
					filter = function(buf)
						return vim.bo[buf].buftype == 'help'
					end,
				},
			},
			left = {
				{ ft = 'blink-tree' },
				{ ft = 'neo-tree' },
			},
			right = {
				{
					ft = 'toggleterm',
					-- exclude floating windows
					filter = function(_, win)
						return vim.api.nvim_win_get_config(win).relative == ''
					end,
				},
			},
		},
	},

	-- live feedback for rename
	{
		'smjonas/inc-rename.nvim',
		keys = {
			{
				'<leader>cr',
				function()
					return ':IncRename ' .. vim.fn.expand('<cword>')
				end,
				expr = true,
				desc = 'Rename',
			},
		},
		config = true,
	},

	-- notifications
	{
		'j-hui/fidget.nvim',
		event = 'VeryLazy',
		opts = {
			notification = { window = { normal_hl = 'Normal' } },
			integration = {
				['nvim-tree'] = {
					enable = false,
				},
				['xcodebuild-nvim'] = {
					enable = false,
				},
			},
		},
	},
}
