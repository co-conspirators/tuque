vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
	pattern = { '*/templates/*.yaml', '*/templates/*.tpl', '*.gotmpl', 'helmfile*.yaml' },
	callback = function()
		vim.opt_local.filetype = 'helm'
	end,
})

return {
	-- treesitter
	{
		'nvim-treesitter/nvim-treesitter',
		opts = function(_, opts)
			if type(opts.ensure_installed) == 'table' then
				vim.list_extend(opts.ensure_installed, { 'yaml' })
			end
		end,
	},
	-- LSP and schemas for autocompletion
	{ 'towolf/vim-helm', ft = 'helm' },
	{
		'someone-stole-my-name/yaml-companion.nvim',
		dependencies = {
			{ 'neovim/nvim-lspconfig' },
			{ 'nvim-lua/plenary.nvim' },
			{ 'nvim-telescope/telescope.nvim' },
		},
		ft = 'yaml',
		keys = {
			{ '<leader>fy', '<cmd>Telescope yaml_schema<CR>', desc = 'YAML Schemas' },
		},
		config = function()
			local cfg = require('yaml-companion').setup()
			require('lspconfig').yamlls.setup(cfg)
			require('lspconfig').helm_ls.setup({
				settings = {
					['helm-ls'] = {
						yamlls = cfg.settings['yamlls'],
					},
				},
			})
			require('telescope').load_extension('yaml_schema')
		end,
	},
}
