local M = {}

-- easier keymapping
function M.map(mode, lhs, rhs, opts)
	opts = opts or { noremap = true }
	opts.silent = opts.silent ~= false
	vim.keymap.set(mode, lhs, rhs, opts)
end

return M
