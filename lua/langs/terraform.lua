vim.filetype.add({
	extension = {
		tf = 'terraform',
	},
})

-- fix terraform and hcl comment string
-- https://neovim.discourse.group/t/commentstring-for-terraform-files-not-set/4066/2
vim.api.nvim_create_autocmd('FileType', {
	group = vim.api.nvim_create_augroup('FixTerraformCommentString', { clear = true }),
	callback = function(ev)
		vim.bo[ev.buf].commentstring = '# %s'
	end,
	pattern = { 'terraform', 'hcl' },
})

return {
	-- formatting
	{
		'stevearc/conform.nvim',
		opts = {
			formatters_by_ft = {
				terraform = { 'terraform_fmt' },
				tf = { 'terraform_fmt' },
				['terraform-vars'] = { 'terraform_fmt' },
			},
		},
	},
	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'terraform', 'hcl' })
			end
		end,
	},
	-- LSP
	{
		'neovim/nvim-lspconfig',
		opts = {
			servers = {
				terraformls = {},
				tflint = {},
			},
		},
	},
}
