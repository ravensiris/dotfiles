---@module 'lazy'
---@type LazySpec
return {
	{
		"ronisbr/emojify.nvim",
		cmd = "Emojify",
		config = function()
			require("emojify").setup({
				inlay = false,
			})
		end,
		lazy = true,
	},
}
