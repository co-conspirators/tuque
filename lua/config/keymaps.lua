local function map(mode, lhs, rhs, opts)
	opts = opts or { noremap = true }
	opts.silent = opts.silent ~= false
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- better up/down - allows moving to wrapped lines
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, '<Down>', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ 'n', 'x' }, '<Up>', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to left window', remap = true })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window', remap = true })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window', remap = true })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to right window', remap = true })

-- buffers
map('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev buffer' })
map('n', ']b', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
map('n', '<leader><backspace>', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- Clear search with <esc>
map({ 'i', 'n' }, '<esc>', '<cmd>noh<cr><esc>', { desc = 'Escape and clear hlsearch' })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map('n', 'n', "'Nn'[v:searchforward].'zv'", { expr = true, desc = 'Next search result' })
map('x', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('o', 'n', "'Nn'[v:searchforward]", { expr = true, desc = 'Next search result' })
map('n', 'N', "'nN'[v:searchforward].'zv'", { expr = true, desc = 'Prev search result' })
map('x', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })
map('o', 'N', "'nN'[v:searchforward]", { expr = true, desc = 'Prev search result' })

-- quit
map('n', '<leader>qq', '<cmd>qa<cr>', { desc = 'Quit all' })
map('n', '<leader>qQ', '<cmd>qa!<cr>', { desc = 'Force quit all' })

-- ctrl based commands
map({ 'i', 'x', 'n', 's' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save file' })
-- map({ 'i', 'x', 'n', 's' }, '<C-S>', '<cmd>SudoWrite<cr><esc>', { desc = 'Save file with sudo' })
map({ 'i', 'n' }, '<C-a>', 'ggVG', { desc = 'Select all' })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- lazy
map('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- ui
map('n', '<leader>uw', '<cmd>set wrap!<cr>', { desc = 'Toggle line wrapping' })

-- diagnostic
local diagnostic_goto = function(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
map('n', ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' })
map('n', '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' })
map('n', ']e', diagnostic_goto(true, 'ERROR'), { desc = 'Next Error' })
map('n', '[e', diagnostic_goto(false, 'ERROR'), { desc = 'Prev Error' })
map('n', ']w', diagnostic_goto(true, 'WARN'), { desc = 'Next Warning' })
map('n', '[w', diagnostic_goto(false, 'WARN'), { desc = 'Prev Warning' })

-- windows
map('n', '<leader>ww', '<C-W>p', { desc = 'Other window', remap = true })
map('n', '<leader>wd', '<C-W>c', { desc = 'Delete window', remap = true })
map('n', '<leader>wh', '<C-W>s', { desc = 'Split window below', remap = true })
map('n', '<leader>wv', '<C-W>v', { desc = 'Split window right', remap = true })

-- debugging
map('n', '<leader>dps', function()
	require('plenary.profile').start('profile.log', { flame = true })
end, { desc = 'Start Lua profiling' })
map('n', '<leader>dpS', function()
	require('plenary.profile').stop()
end, { desc = 'Stop Lua profiling' })

-- clipboard
map('v', '<leader>p', '"+p', { desc = 'Paste from clipboard' })
map('n', '<leader>p', '"+p', { desc = 'Paste from clipboard' })
map('v', '<leader>P', '"+P', { desc = 'Paste from clipboard' })
map('n', '<leader>P', '"+P', { desc = 'Paste from clipboard' })
map('v', '<leader>y', '"+y', { desc = 'Yank to clipboard' })
map('v', '<leader>Y', function()
	local curl = require('plenary.curl')
	local strings = require('plenary.strings')
	local filetype_to_extensions = {
		lua = 'lua',
		typescript = 'ts',
		javascript = 'js',
		typescriptreact = 'tsx',
		javascriptreact = 'jsx',
		markdown = 'md',
		json = 'json',
		yaml = 'yaml',
		toml = 'toml',
		html = 'html',
		css = 'css',
		scss = 'scss',
		sass = 'sass',
		less = 'less',
		graphql = 'graphql',
		sql = 'sql',
		vim = 'vim',
		sh = 'sh',
		fish = 'fish',
		zsh = 'zsh',
		bash = 'bash',
		python = 'py',
		rust = 'rs',
		go = 'go',
		java = 'java',
		c = 'c',
		cpp = 'cpp',
		tsx = 'tsx',
		jsx = 'jsx',
		php = 'php',
		ruby = 'rb',
		r = 'r',
		ocaml = 'ml',
		haskell = 'hs',
		scala = 'scala',
		clojure = 'clj',
		elixir = 'ex',
		erlang = 'erl',
		dart = 'dart',
		nim = 'nim',
		purescript = 'purs',
		reason = 're',
		svelte = 'svelte',
		vue = 'vue',
		crystal = 'cr',
		zig = 'zig',
		julia = 'jl',
		racket = 'rkt',
		scheme = 'scm',
		lisp = 'lisp',
		fennel = 'fnl',
		moonscript = 'moon',
		nix = 'nix',
	}

	vim.cmd.normal({ '"zy', bang = true })
	local selected_text = strings.dedent(vim.fn.getreg('z'))

	local response = curl.post('https://paste.super.fish/', {
		method = 'POST',
		body = selected_text,
	})

	local redirect_url = response.body
	local extension = filetype_to_extensions[vim.bo.filetype] or 'txt'
	if redirect_url then
		vim.fn.setreg('+', 'https://paste.super.fish' .. redirect_url .. '.' .. extension)
		vim.notify('Copied to clipboard and system clipboard')
	else
		vim.notify('Failed to upload to pastebin')
	end
end, { desc = 'Upload selection to paste bin' })
