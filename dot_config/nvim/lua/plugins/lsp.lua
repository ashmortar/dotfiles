return {
	-- LSP Configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
		},
		config = function()
			-- Setup mason first
			require("mason").setup({
				ui = {
					border = "rounded",
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			require("mason-lspconfig").setup({
				ensure_installed = {
					"basedpyright",
					"ruff",
					"ts_ls",
					"gopls",
					"lua_ls",
				},
				automatic_installation = true,
			})

			-- Setup neodev for Neovim lua development
			require("neodev").setup()

			-- LSP settings
			local lspconfig = require("lspconfig")
			local capabilities = vim.lsp.protocol.make_client_capabilities()

			-- Common on_attach function
			local on_attach = function(client, bufnr)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
				end

				map("gd", vim.lsp.buf.definition, "Goto Definition")
				map("gr", vim.lsp.buf.references, "Goto References")
				map("gI", vim.lsp.buf.implementation, "Goto Implementation")
				map("<leader>ld", vim.lsp.buf.type_definition, "Type Definition")
				map("<leader>ls", vim.lsp.buf.document_symbol, "Document Symbols")
				map("<leader>lw", vim.lsp.buf.workspace_symbol, "Workspace Symbols")
				map("<leader>lr", vim.lsp.buf.rename, "Rename")
				map("<leader>la", vim.lsp.buf.code_action, "Code Action")
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("gD", vim.lsp.buf.declaration, "Goto Declaration")
			end

			-- Python
			lspconfig.basedpyright.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					basedpyright = {
						analysis = {
							typeCheckingMode = "basic",
							autoImportCompletions = true,
						},
					},
				},
			})

			lspconfig.ruff.setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- TypeScript
			require("typescript-tools").setup({
				on_attach = on_attach,
				settings = {
					complete_function_calls = true,
					include_completions_with_insert_text = true,
				},
			})

			-- Go
			lspconfig.gopls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					gopls = {
						analyses = {
							unusedparams = true,
						},
						staticcheck = true,
						gofumpt = true,
					},
				},
			})

			-- Lua
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					Lua = {
						workspace = {
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			})
		end,
	},

	-- TypeScript tools
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	},
}
