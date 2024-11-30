local shaded_filetypes = { 'Avante', 'AvanteInput' }
vim.api.nvim_create_autocmd({ 'BufEnter', 'WinEnter' }, {
	callback = function()
		if not vim.tbl_contains(shaded_filetypes, vim.bo.filetype) then
			return
		end
		vim.cmd(
			'setlocal winhighlight=Normal:AvanteNormal,NormalNC:AvanteNormal,EndOfBuffer:AvanteNormal,SignColumn:BlinkTreeSignColumn,FloatBorder:AvanteNormal,StatusLine:AvanteStatusLine,StatusLineNC:AvanteStatusLine,VertSplit:AvanteNormal'
		)

		-- hack: for avante input window
		vim.schedule(function()
			if not vim.tbl_contains(shaded_filetypes, vim.bo.filetype) then
				return
			end
			vim.cmd(
				'setlocal winhighlight=Normal:AvanteNormal,NormalNC:AvanteNormal,EndOfBuffer:AvanteNormal,SignColumn:BlinkTreeSignColumn,FloatBorder:AvanteNormal,StatusLine:AvanteStatusLine,StatusLineNC:AvanteStatusLine,VertSplit:AvanteNormal'
			)
			if vim.bo.filetype == 'AvanteInput' then
				vim.schedule(function()
					vim.cmd('startinsert')
				end)
			end
		end)
	end,
})
