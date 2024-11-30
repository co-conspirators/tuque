vim.api.nvim_create_autocmd('FileType', {
	pattern = 'java',
	desc = 'Setup jdtls',
	callback = function()
		require('jdtls').start_or_attach({
			capabilities = require('blink.cmp').get_lsp_capabilities(),
			cmd = { 'jdtls' },
			root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
		})
	end,
})

return {
	{ 'mfussenegger/nvim-jdtls', ft = 'java' },
}
