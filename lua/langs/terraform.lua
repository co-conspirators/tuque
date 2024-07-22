-- default detection doesnt work on new files
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
	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'terraform', 'hcl' })
			end
		end,
	},
	-- LSP/formatting
	{
		'neovim/nvim-lspconfig',
		opts = function(_, opts)
			opts.servers.terraformls = {}
			opts.servers.tflint = {}

			vim.list_extend(opts.servers.efm.filetypes, {
				'terraform',
				'tf',
				'terraform-vars',
			})
			local terraform_fmt = require('efmls-configs.formatters.terraform_fmt')
			opts.servers.efm.languages.terraform = { terraform_fmt }
			opts.servers.efm.languages.tf = { terraform_fmt }
			opts.servers.efm.languages['terraform-vars'] = { terraform_fmt }
		end,
	},
}
