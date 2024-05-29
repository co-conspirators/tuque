return {
	{
		'rebelot/heirline.nvim',
		dependencies = { 'lewis6991/gitsigns.nvim' },
		config = function()
			local heirline = require('heirline')

			local conditions = require('heirline.conditions')
			local utils = require('heirline.utils')

			local last_code_bufnr = 0
			vim.api.nvim_create_autocmd('BufEnter', {
				callback = function()
					local bufnr = vim.api.nvim_get_current_buf()
					local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })

					if buftype == 'nofile' then
						return
					end

					last_code_bufnr = bufnr
				end,
			})

			heirline.load_colors(function()
				return {
					bg = utils.get_highlight('StatusLine').bg,
					fg = utils.get_highlight('StatusLine').fg,
					bright_bg = utils.get_highlight('Folded').bg,
					bright_fg = utils.get_highlight('Folded').fg,
					red = utils.get_highlight('Red').fg,
					dark_red = utils.get_highlight('DiffDelete').bg,
					green = utils.get_highlight('Green').fg,
					blue = utils.get_highlight('Blue').fg,
					gray = utils.get_highlight('NonText').fg,
					orange = utils.get_highlight('Orange').fg,
					purple = utils.get_highlight('Purple').fg,
					cyan = utils.get_highlight('Cyan').fg,
					yellow = utils.get_highlight('Yellow').fg,
					diag_warn = utils.get_highlight('DiagnosticWarn').fg,
					diag_error = utils.get_highlight('DiagnosticError').fg,
					diag_hint = utils.get_highlight('DiagnosticHint').fg,
					diag_info = utils.get_highlight('DiagnosticInfo').fg,
					git_del = utils.get_highlight('diffDeleted').fg,
					git_add = utils.get_highlight('diffAdded').fg,
					git_change = utils.get_highlight('diffChanged').fg,
				}
			end)

			local Gap = {
				provider = function()
					return '  '
				end,
				hl = function()
					return { fg = 'bg' }
				end,
			}

			local Mode = {
				-- get vim current mode, this information will be required by the provider
				-- and the highlight functions, so we compute it only once per component
				-- evaluation and store it as a component attribute
				init = function(self)
					self.mode = vim.fn.mode(1) -- :h mode()
				end,
				static = {
					mode_names = {
						n = 'NORMAL',
						v = 'VISUAL',
						V = 'VISUAL',
						['\22'] = 'VISUAL',
						s = 'SUBSTU',
						S = 'SUBSTU',
						['\19'] = 'SUBSTI',
						i = 'INSERT',
						R = 'REPLAC',
						c = 'COMMND',
						r = 'REPLCE',
						['!'] = 'EXCLAM',
						t = 'TERMNL',
					},
					mode_colors = {
						n = 'green',
						i = 'yellow',
						v = 'purple',
						V = 'purple',
						['\22'] = 'purple',
						c = 'red',
						s = 'purple',
						S = 'purple',
						['\19'] = 'purple',
						R = 'orange',
						r = 'orange',
						['!'] = 'red',
						t = 'red',
					},
				},
				provider = function(self)
					return '  ' .. self.mode_names[self.mode:sub(1, 1)]
				end,
				hl = function(self)
					local mode = self.mode:sub(1, 1)
					return { fg = self.mode_colors[mode], bold = true }
				end,
				update = {
					'ModeChanged',
					pattern = '*:*',
					callback = vim.schedule_wrap(function()
						vim.cmd('redrawstatus')
					end),
				},
			}

			local Git = {
				condition = conditions.is_git_repo,

				init = function(self)
					self.status_dict = vim.b.gitsigns_status_dict
					self.has_changes = self.status_dict.added ~= 0
						or self.status_dict.removed ~= 0
						or self.status_dict.changed ~= 0
				end,

				hl = { fg = 'yellow' },

				{ -- git branch name
					provider = function(self)
						return ' ' .. self.status_dict.head
					end,
					hl = { bold = true },
				},
				-- You could handle delimiters, icons and counts similar to Diagnostics
				{
					provider = function(self)
						local count = self.status_dict.added or 0
						return count > 0 and ('    ' .. count)
					end,
					hl = { fg = 'git_add' },
				},
				{
					provider = function(self)
						local count = self.status_dict.removed or 0
						return count > 0 and ('    ' .. count)
					end,
					hl = { fg = 'git_del' },
				},
				{
					provider = function(self)
						local count = self.status_dict.changed or 0
						return count > 0 and ('    ' .. count)
					end,
					hl = { fg = 'git_change' },
				},
			}

			local LSPActive = {
				condition = function()
					return next(vim.lsp.get_clients({ buf = last_code_bufnr })) ~= nil
				end,
				update = { 'LspAttach', 'LspDetach' },
				provider = function()
					local names = {}
					for _, server in pairs(vim.lsp.get_clients({ buf = last_code_bufnr })) do
						if server.name ~= 'copilot' then
							table.insert(names, server.name)
						end
					end
					return '  ' .. table.concat(names, ' ')
				end,
				hl = { fg = 'purple' },
			}

			local Diagnostics = {
				static = {
					error_icon = vim.fn.sign_getdefined('DiagnosticSignError')[1].text,
					warn_icon = vim.fn.sign_getdefined('DiagnosticSignWarn')[1].text,
					info_icon = vim.fn.sign_getdefined('DiagnosticSignInfo')[1].text,
					hint_icon = vim.fn.sign_getdefined('DiagnosticSignHint')[1].text,
				},

				init = function(self)
					if not vim.api.nvim_buf_is_valid(last_code_bufnr) then
						self.errors = 0
						self.warnings = 0
						self.hints = 0
						self.info = 0
						return
					end
					self.errors = #vim.diagnostic.get(last_code_bufnr, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(last_code_bufnr, { severity = vim.diagnostic.severity.WARN })
					self.hints = #vim.diagnostic.get(last_code_bufnr, { severity = vim.diagnostic.severity.HINT })
					self.info = #vim.diagnostic.get(last_code_bufnr, { severity = vim.diagnostic.severity.INFO })
				end,

				update = { 'DiagnosticChanged', 'BufEnter' },

				{
					provider = function(self)
						-- 0 is just another output, we can decide to print it or not!
						return self.errors > 0 and (self.error_icon .. ' ' .. self.errors .. ' ')
					end,
					hl = { fg = 'diag_error' },
				},
				{
					provider = function(self)
						return self.warnings > 0 and (self.warn_icon .. ' ' .. self.warnings .. ' ')
					end,
					hl = { fg = 'diag_warn' },
				},
				{
					provider = function(self)
						return self.info > 0 and (self.info_icon .. ' ' .. self.info .. ' ')
					end,
					hl = { fg = 'diag_info' },
				},
				{
					provider = function(self)
						return self.hints > 0 and (self.hint_icon .. ' ' .. self.hints)
					end,
					hl = { fg = 'diag_hint' },
				},
			}

			local FileType = {
				provider = function()
					if not vim.api.nvim_buf_is_valid(last_code_bufnr) then
						return ''
					end

					local filetype = vim.api.nvim_get_option_value('filetype', { buf = last_code_bufnr })
					local icon = require('nvim-web-devicons').get_icon_by_filetype(filetype)
					if icon == nil then
						return ''
					end
					return icon .. '  ' .. filetype
				end,
				hl = function()
					local filetype = vim.api.nvim_get_option_value('filetype', { buf = last_code_bufnr })
					local _, color = require('nvim-web-devicons').get_icon_color_by_filetype(filetype)
					if color == nil then
						return { fg = 'blue' }
					end
					return { fg = color }
				end,
			}

			local Fill = {
				provider = function()
					return '%='
				end,
				hl = function()
					return { fg = 'bg' }
				end,
			}

			heirline.setup({
				statusline = {
					hl = { fg = 'fg', bg = 'bg' },
					Gap,
					Mode,
					Gap,
					Git,
					Fill,
					Diagnostics,
					Gap,
					LSPActive,
					Gap,
					FileType,
					Gap,
				},
			})
		end,
	},
}
