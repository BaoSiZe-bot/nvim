return {
	{
		"SCJangra/table-nvim",
		ft = "markdown",
		opts = {
			padd_column_separators = true, -- Insert a space around column separators.
			mappings = { -- next and prev work in Normal and Insert mode. All other mappings work in Normal mode.
				next = "<TAB>", -- Go to next cell.
				prev = "<S-TAB>", -- Go to previous cell.
				insert_row_up = "<A-k>", -- Insert a row above the current row.
				insert_row_down = "<A-j>", -- Insert a row below the current row.
				move_row_up = "<A-S-k>", -- Move the current row up.
				move_row_down = "<A-S-j>", -- Move the current row down.
				insert_column_left = "<A-h>", -- Insert a column to the left of current column.
				insert_column_right = "<A-l>", -- Insert a column to the right of current column.
				move_column_left = "<A-S-h>", -- Move the current column to the left.
				move_column_right = "<A-S-l>", -- Move the current column to the right.
				insert_table = "<A-t>", -- Insert a new table.
				insert_table_alt = "<A-S-t>", -- Insert a new table that is not surrounded by pipes.
				delete_column = "<A-d>", -- Delete the column under cursor.
			},
		},
	},
	{
		"michaelb/sniprun",
		branch = "master",
		build = "sh install.sh 1",
		-- do 'sh install.sh 1' if you want to force compile locally, 'sh install.sh' else
		-- (instead of fetching a binary from the github release). Requires Rust >= 1.65
		keys = {
			{
				"<leader>ce",
				function()
					require("sniprun").run()
				end,
				desc = "Eval Code Block",
				mode = "n",
				ft = { "markdown", "org", "norg" },
			},
			{
				"<leader>ce",
				function()
					require("sniprun").run("v")
				end,
				desc = "Eval Code Block",
				mode = "v",
				ft = { "markdown", "org", "norg" },
			},
		},
		opts = {
			display = {
				"VirtualLine",
			},
		},
	},
	{
		"jmbuhr/otter.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			buffers = {
				set_filetype = true,
				write_to_disk = true,
			},
		},
		keys = {
			{
				"<leader>cb",
				function()
					require("otter").activate()
				end,
				desc = "Active Lsp in Code Block",
				ft = { "markdown", "org", "norg" },
			},
			{
				"<leader>cB",
				function()
					require("otter").deactivate()
				end,
				desc = "Deactivate Lsp in Code Block",
				ft = { "markdown", "org", "norg" },
			},
		},
		config = function(_, opts)
			local otter = require("otter")
			otter.setup(opts)
		end,
	},
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = function()
			require("lazy").load({ plugins = { "markdown-preview.nvim" } })
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{
				"<leader>cp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
		config = function()
			vim.cmd([[do FileType]])
		end,
	},

	-- For `plugins/markview.lua` users.
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		config = function()
			local presets = require("markview.presets")
			require("markview").setup({
				---@diagnostic disable-next-line: missing-fields
				markdown = {
					enable = true,
					headings = presets.headings.glow_center,
					horizontal_rules = presets.horizontal_rules.thin,
					tables = presets.tables.rounded,
				},
				latex = {
					enable = false,
					subscripts = { enable = true, fake_preview = false },
				},
				preview = {
					icon_provider = "mini",
					enable_hybrid_mode = true,
					hybrid_modes = { "n", "no", "c", "i", "v" },
					modes = { "n", "no", "c", "i", "v" },
					filetypes = {
						"markdown",
						"quarto",
						"typst",
						"norg",
						"rmd",
						"org",
						"codecompanion",
						"Avante",
					},
				},
			})
			require("markview.extras.checkboxes").setup({
				--- Default checkbox state(used when adding checkboxes).
				---@type string
				default = " ",

				--- Changes how checkboxes are removed.
				---@type
				---| "disable" Disables the checkbox.
				---| "checkbox" Removes the checkbox.
				---| "list_item" Removes the list item markers too.
				remove_style = "checkbox",

				--- Various checkbox states.
				---
				--- States are in sets to quickly change between them
				--- when there are a lot of states.
				---@type string[][]
				states = {
					{ " ", "/", "X" },
					{ "<", ">" },
					{ "?", "!", "*" },
					{ '"' },
					{ "l", "b", "i" },
					{ "S", "I" },
					{ "p", "c" },
					{ "f", "k", "w" },
					{ "u", "d" },
				},
			})
			-- require("markview.extras.editor").setup()
		end,
		dependencies = { "catppuccin/nvim" },
		keys = {
			{
				"<leader>ct",
				"<cmd>Checkbox toggle<cr>",
				desc = "toggle Checkmark",
				ft = "markdown",
				mode = { "n", "v" },
			},
		},
		-- Completion for `blink.cmp`
		-- dependencies = { "saghen/blink.cmp" },
	},
	{
		"stevearc/conform.nvim",
		optional = true,
		opts = {
			formatters = {
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
			},
			formatters_by_ft = {
				["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
				["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		optional = true,
		opts = function(_, opts)
			opts.lsps = vim.list_extend(opts.lsps, { "markdown" })
			return opts
		end,
	},
}
