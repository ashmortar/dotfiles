return {
	"OXY2DEV/markview.nvim",
	lazy = false, -- IMPORTANT: Don't lazy load
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.icons", -- You already have this
	},
	config = function()
		local markview = require("markview")
		local presets = require("markview.presets")

		markview.setup({
			-- Experimental settings
			experimental = {
				-- Keep defaults for most of these
				link_open_alerts = false,
				prefer_nvim = true,
			},

			-- Preview configuration - THIS IS WHERE modes and hybrid_modes go!
			preview = {
				enable = true,
				filetypes = { "md", "rmd", "quarto" },
				ignore_buftypes = { "nofile" },
				-- Modes configuration (moved here from top level)
				modes = { "n", "no", "c" },
				-- Hybrid mode configuration (moved here from top level)
				hybrid_modes = { "n" }, -- This enables hybrid mode in normal mode
				-- Icon provider
				icon_provider = "mini", -- Use mini icons since you have it
				-- Performance
				debounce = 50,
				-- Draw range
				draw_range = { vim.o.lines, vim.o.lines },
				-- Edit range for hybrid mode
				edit_range = { 1, 0 },
			},

			-- Markdown configuration
			markdown = {
				enable = true,
				-- Headings with slanted preset
				headings = presets.headings.slanted,
				-- Tables with rounded preset
				tables = presets.tables.rounded,
				-- Block quotes
				block_quotes = {
					enable = true,
					default = {
						border = "▌",
					},
				},
				-- Code blocks
				code_blocks = {
					enable = true,
					style = "minimal",
					min_width = 60,
					language_direction = "right",
					sign = false, -- Disable signs in gutter
				},
				-- List items
				list_items = {
					enable = true,
					marker_plus = {
						text = "•",
					},
					marker_minus = {
						text = "•",
					},
					marker_star = {
						text = "•",
					},
				},
			},

			-- Markdown inline configuration
			markdown_inline = {
				enable = true,
				-- Checkboxes
				checkboxes = {
					enable = true,
					checked = {
						text = "✓",
						hl = "MarkviewCheckboxChecked",
					},
					unchecked = {
						text = "✗",
						hl = "MarkviewCheckboxUnchecked",
					},
					pending = {
						text = "•",
						hl = "MarkviewCheckboxPending",
					},
				},
				-- Inline code
				inline_codes = {
					enable = true,
					hl = "MarkviewInlineCode",
				},
				-- Hyperlinks
				hyperlinks = {
					enable = true,
					hl = "MarkviewHyperlink",
				},
				-- Images
				images = {
					enable = true,
					hl = "MarkviewImage",
				},
			},

			-- LaTeX support (optional)
			latex = {
				enable = true,
				symbols = {
					enable = true,
				},
			},

			-- YAML frontmatter
			yaml = {
				enable = true,
				properties = {
					enable = true,
				},
			},
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>mp", "<cmd>Markview toggle<cr>", { desc = "Toggle Markview" })
		vim.keymap.set("n", "<leader>ms", "<cmd>Markview splitToggle<cr>", { desc = "Toggle Split View" })
		vim.keymap.set("n", "<leader>mh", "<cmd>Markview hybridToggle<cr>", { desc = "Toggle Hybrid Mode" })

		-- Optional: Setup checkbox extras for interactive toggling
		local ok, checkboxes = pcall(require, "markview.extras.checkboxes")
		if ok then
			checkboxes.setup()
			vim.keymap.set("n", "<leader>mc", function()
				vim.cmd("Checkbox interactive")
			end, { desc = "Interactive Checkbox" })
		end

		-- Optional: Setup headings extras
		local ok_headings, headings = pcall(require, "markview.extras.headings")
		if ok_headings then
			headings.setup()
			vim.keymap.set("n", "<leader>mH", function()
				headings.increase()
			end, { desc = "Increase Heading Level" })
			vim.keymap.set("n", "<leader>mL", function()
				headings.decrease()
			end, { desc = "Decrease Heading Level" })
		end
	end,
}
