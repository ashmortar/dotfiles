return {
	-- Collection of various small independent plugins/modules
	{
		"echasnovski/mini.nvim",
		version = false,
		config = function()
			-- Better Around/Inside textobjects
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			-- Examples:
			--  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			--  - sd'   - [S]urround [D]elete [']quotes
			--  - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			-- Session management
			require("mini.sessions").setup({
				autoread = false,
				autowrite = true,
				directory = vim.fn.stdpath("data") .. "/sessions/",
				file = "session.vim",
			})

			-- Start screen
			local starter = require("mini.starter")
			starter.setup({
				items = {
					starter.sections.sessions(5, true),
					starter.sections.recent_files(5, false, true),
					starter.sections.builtin_actions(),
				},
				content_hooks = {
					starter.gen_hook.adding_bullet(),
					starter.gen_hook.aligning("center", "center"),
				},
			})
		end,
	},
}
