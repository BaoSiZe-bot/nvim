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
		"nfrid/markdown-togglecheck",
		dependencies = { "nfrid/treesitter-utils" },
		ft = { "markdown" },
		keys = {
			-- toggle checked / create checkbox if it doesn't exist
			{
				"<leader>ct",
				function()
					vim.go.operatorfunc = "v:lua.require'markdown-togglecheck'.toggle"
					return "g@l"
				end,
				desc = "toggle Checkmark",
				ft = "markdown",
			},
			-- toggle checkbox (it doesn't remember toggle state and always creates [ ])
			-- {
			--     "<leader>ct",
			--     function()
			--         vim.go.operatorfunc = "v:lua.require'markdown-togglecheck'.togglebox"
			--         return 'g@l'
			--     end,
			--     desc = "toggle Checkbox",
			--     ft = "markdown"
			-- }
		},
	},
	{
		"jubnzv/mdeval.nvim",
		ft = { "markdown", "org", "norg" },
		keys = {
			{
				"<leader>ce",
				function()
					require("mdeval").eval_code_block()
				end,
				silent = true,
				noremap = true,
				desc = "Eval Code Block",
				ft = { "markdown", "org", "norg" },
			},
		},
		opts = {},
	},
	{
		"AckslD/nvim-FeMaco.lua",
		ft = { "markdown", "org", "norg" },
		keys = {
			{
				"<leader>cb",
				function()
					require("femaco.edit").edit_code_block()
				end,
				desc = "Extract Code Block",
				ft = { "markdown", "org", "norg" },
			},
		},
		opts = {},
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
	{
		"MeanderingProgrammer/render-markdown.nvim",
		opts = {
			code = {
				sign = true,
				width = "block",
				right_pad = 1,
			},
			heading = {
				sign = true,
				-- icons = {},
			},
			checkbox = {
				enabled = true,
			},
			file_types = { "markdown", "norg", "rmd", "org", "codecompanion", "Avante" },
		},
		ft = { "markdown", "norg", "rmd", "org", "codecompanion", "Avante" },
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
}
