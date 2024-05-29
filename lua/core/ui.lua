return {
	-- top bar
	{
		'ramilito/winbar.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {
			icons = true,
			diagnostics = true,
			buf_modified = true,
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
				{
					ft = 'neo-tree',
				},
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

	-- experimental UI
	{
		'folke/noice.nvim',
		dependencies = { 'MunifTanjim/nui.nvim', 'j-hui/fidget.nvim' },
		opts = {
			presets = {
				inc_rename = true, -- enables an input dialog for inc-rename.nvim
			},
			messages = {
        enabled = true,
        -- view = 'fidget',
        -- view_warn = 'fidget',
        -- view_error = 'fidget',
      },
			notify = { enabled = false, view = 'fidget' },
			popupmenu = { enabled = false },
			lsp = {
				progress = { enabled = false, view = 'fidget' },
				-- provides signature help while typing
				signature = { enabled = true },
			},
		},
		config = function(_, opts)
			local require = require('noice.util.lazy')

			local Util = require('noice.util')
			local View = require('noice.view')

			---@class NoiceFidgetOptions
			---@field timeout integer
			---@field reverse? boolean
			local defaults = { timeout = 5000 }

			---@class FidgetView: NoiceView
			---@field active table<number, NoiceMessage>
			---@field super NoiceView
			---@field lsp_handles table<number, ProgressHandle>
			---@field timers table<number, uv_timer_t>
			---@diagnostic disable-next-line: undefined-field
			local FidgetView = View:extend('MiniView')

			function FidgetView:init(opts)
				FidgetView.super.init(self, opts)
				self.active = {}
				self.timers = {}
				self._instance = 'view'
				self.lsp_handles = {}
			end

			function FidgetView:update_options()
				self._opts = vim.tbl_deep_extend('force', defaults, self._opts)
			end

			---@param message NoiceMessage
			function FidgetView:can_hide(message)
				if message.opts.keep and message.opts.keep() then
					return false
				end
				return not Util.is_blocking()
			end

			function FidgetView:autohide(id)
				if not id then
					return
				end
				if not self.timers[id] then
					self.timers[id] = vim.loop.new_timer()
				end
				self.timers[id]:start(self._opts.timeout, 0, function()
					if not self.active[id] then
						return
					end
					if not self:can_hide(self.active[id]) then
						return self:autohide(id)
					end
					self.active[id] = nil
					self.timers[id] = nil
					vim.schedule(function()
						self:update()
					end)
				end)
			end

			function FidgetView:show()
				for _, message in ipairs(self._messages) do
					-- we already have debug info,
					-- so make sure we dont regen it in the child view
					message._debug = true
					self.active[message.id] = message
					self:autohide(message.id)
				end
				self:clear()
				self:update()
			end

			function FidgetView:dismiss()
				self:clear()
				self.active = {}
				self:update()
			end

			function FidgetView:update()
				---@type NoiceMessage[]
				local active = vim.tbl_values(self.active)
        -- sort by id
				table.sort(
					active,
					---@param a NoiceMessage
					---@param b NoiceMessage
					function(a, b)
						local ret = a.id < b.id
						if self._opts.reverse then
							return not ret
						end
						return ret
					end
				)

        self:_handle_lsp(active)
        self:_handle_messages(active)
        self:_handle_notify(active)
      end

      ---@param messages NoiceMessage[]
      function FidgetView:_handle_lsp(messages)
        local fidget = require('fidget')

        ---@type NoiceMessage[]
        local lsp_messages = vim.tbl_filter(function(message)
          return message.event == 'lsp'
        end, messages)

				for _, message in pairs(lsp_messages) do
					if self.lsp_handles[message.id] then
						self.lsp_handles[message.id]:report({
							message = message:content(),
						})
					else
						self.lsp_handles[message.id] = fidget.progress.handle.create({
							title = message.level or 'info',
							message = message:content(),
							level = message.level,
							lsp_client = {
								name = self._view_opts.title or 'noice',
							},
						})
					end
				end

        -- finish lsp handles that are no longer active
				for id, handle in pairs(self.lsp_handles) do
          for _, message in pairs(lsp_messages) do
            if message.id == id then
              goto continue
            end
          end

          handle:finish()
          self.lsp_handles[id] = nil

          ::continue::
				end
      end

      ---@param messages NoiceMessage[]
      function FidgetView:_handle_messages(messages)
        local notify = require('fidget.notification').notify

        local events = require('noice.ui.msg').events

        ---@type NoiceMessage[]
        local msgs = vim.tbl_filter(function(message)
          for _, event in pairs(events) do
            if message.event == event then
              return true
            end
          end
          return false
        end, messages)

        for _, message in pairs(msgs) do
          notify(message:content(), message.level)
        end
      end

      ---@param messages NoiceMessage[]
      function FidgetView:_handle_notify(messages)
        local notify = require('fidget.notification').notify

        ---@type NoiceMessage[]
        local notifications = vim.tbl_filter(function(message)
          return message.event == 'notify'
        end, messages)

        for _, message in pairs(notifications) do
          notify(message:content(), message.level)
        end
      end

			function FidgetView:hide()
				for _, handle in pairs(self.lsp_handles) do
					handle:finish()
				end
			end

			package.loaded['noice.view.backend.fidget'] = FidgetView

			require('noice').setup(opts)
		end,
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
	 opts = {
     notification = { window = { normal_hl = 'Normal' } }
	 },
	},
}
