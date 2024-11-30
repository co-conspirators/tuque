return {
	'L3MON4D3/LuaSnip',
	dependencies = { 'rafamadriz/friendly-snippets' },
	version = 'v2.*',
	build = 'make install_jsregexp',
	config = function()
		local paths = {}
		for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
			if string.match(path, 'friendly.snippets') then
				table.insert(paths, path)
			end
		end
		require('luasnip.loaders.from_vscode').lazy_load({ paths = paths })

		local ls = require('luasnip')
		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node
		local f = ls.function_node
		local c = ls.choice_node
		local d = ls.dynamic_node
		local r = ls.restore_node
		local sn = ls.snippet_node
		local fmt = require('luasnip.extras.fmt').fmt

		-- copy the current selection to the clipboard
		local copy = function()
			local text = vim.fn.getreg('+')
			vim.fn.setreg('+', text)
			return text
		end

		ls.add_snippets('all', {
			-- trigger is `fn`, second argument to snippet-constructor are the nodes to insert into the buffer on expansion.
			s('fn', {
				-- Simple static text.
				t('//Parameters: '),
				-- function, first parameter is the function, second the Placeholders
				-- whose text it gets as input.
				f(copy, 2),
				t({ '', 'function ' }),
				-- Placeholder/Insert.
				i(1),
				t('('),
				-- Placeholder with initial text.
				i(2, 'int foo'),
				-- Linebreak
				t({ ') {', '\t' }),
				-- Last Placeholder, exit Point of the snippet.
				i(0),
				t({ '', '}' }),
			}),
		})
	end,
}
