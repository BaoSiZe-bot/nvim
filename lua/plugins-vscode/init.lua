return {
	-- Treesitter is a new parser generator tool that we can
	-- use in Neovim to power faster and more accurate
	-- syntax highlighting.
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		version = false, -- last release is way too old and doesn't work on Windows
		build = function()
			local TS = require("nvim-treesitter")
			TS.update(nil, { summary = true })
		end,
		lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
		event = { "LazyFile", "VeryLazy" },
		cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
		opts_extend = { "ensure_installed" },
		opts = {
			indent = { enable = true },
			highlight = { enable = true },
			folds = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"jsonc",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"printf",
				"python",
				"query",
				"regex",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
			},
		},
		config = function(_, opts)
			local TS = require("nvim-treesitter")

			-- some quick sanity checks
			-- setup treesitter
			TS.setup(opts)
			-- LazyVim.treesitter.get_installed(true) -- initialize the installed langs

			-- install missing parsers
			-- local install = vim.tbl_filter(function(lang)
			--   return not LazyVim.treesitter.have(lang)
			-- end, opts.ensure_installed or {})
			-- if #install > 0 then
			--   LazyVim.treesitter.ensure_treesitter_cli(function()
			--     TS.install(install, { summary = true }):await(function()
			--       LazyVim.treesitter.get_installed(true) -- refresh the installed langs
			--     end)
			--   end)
			-- end

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("nvim_treesitter", { clear = true }),
				callback = function(ev)
					-- highlighting
					if vim.tbl_get(opts, "highlight", "enable") ~= false then
						pcall(vim.treesitter.start)
					end

					-- indents
					if vim.tbl_get(opts, "indent", "enable") ~= false then
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end

					-- folds
					if vim.tbl_get(opts, "folds", "enable") ~= false then
						vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
					end
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		event = "VeryLazy",
		opts = {
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				keys = {
					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]a"] = "@parameter.inner",
					},
					goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[a"] = "@parameter.inner",
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
						["[A"] = "@parameter.inner",
					},
				},
			},
		},
		config = function(_, opts)
			local TS = require("nvim-treesitter-textobjects")
			if not TS.setup then
				print("Please use `:Lazy` and update `nvim-treesitter`")
				return
			end
			TS.setup(opts)

			vim.api.nvim_create_autocmd("FileType", {
				group = vim.api.nvim_create_augroup("nvim_treesitter_textobjects", { clear = true }),
				callback = function(ev)
					if not vim.tbl_get(opts, "move", "enable") then
						return
					end
					---@type table<string, table<string, string>>
					local moves = vim.tbl_get(opts, "move", "keys") or {}

					for method, keymaps in pairs(moves) do
						for key, query in pairs(keymaps) do
							local desc = query:gsub("@", ""):gsub("%..*", "")
							desc = desc:sub(1, 1):upper() .. desc:sub(2)
							desc = (key:sub(1, 1) == "[" and "Prev " or "Next ") .. desc
							desc = desc .. (key:sub(2, 2) == key:sub(2, 2):upper() and " End" or " Start")
							if not (vim.wo.diff and key:find("[cC]")) then
								vim.keymap.set({ "n", "x", "o" }, key, function()
									require("nvim-treesitter-textobjects.move")[method](query, "textobjects")
								end, {
									buffer = ev.buf,
									desc = desc,
									silent = true,
								})
							end
						end
					end
				end,
			})
		end,
	},

	-- Automatically add closing tags for HTML and JSX
	-- {
	--     "windwp/nvim-ts-autotag",
	--     event = "LazyFile",
	--     opts = {},
	-- },

	-- {
	-- 	"nvim-treesitter/nvim-treesitter-context",
	-- 	event = "LazyFile",
	-- 	opts = {},
	-- },

	-- {
	-- 	"nvim-mini/mini.surround",
	-- 	recommended = true,
	-- 	keys = function(_, keys)
	-- 		-- Populate the keys based on the user's options
	-- 		local mappings = {
	-- 			{ "gsa", desc = "Add Surrounding", mode = { "n", "v" } },
	-- 			{ "gsd", desc = "Delete Surrounding" },
	-- 			{ "gsF", desc = "Find Right Surrounding" },
	-- 			{ "gsf", desc = "Find Left Surrounding" },
	-- 			{ "gsh", desc = "Highlight Surrounding" },
	-- 			{ "gsr", desc = "Replace Surrounding" },
	-- 			{ "gsn", desc = "Update `MiniSurround.config.n_lines`" },
	-- 		}
	-- 		mappings = vim.tbl_filter(function(m)
	-- 			return m[1] and #m[1] > 0
	-- 		end, mappings)
	-- 		return vim.list_extend(mappings, keys)
	-- 	end,
	-- 	opts = {
	-- 		mappings = {
	-- 			add = "gsa", -- Add surrounding in Normal and Visual modes
	-- 			delete = "gsd", -- Delete surrounding
	-- 			find = "gsf", -- Find surrounding (to the right)
	-- 			find_left = "gsF", -- Find surrounding (to the left)
	-- 			highlight = "gsh", -- Highlight surrounding
	-- 			replace = "gsr", -- Replace surrounding
	-- 			update_n_lines = "gsn", -- Update `n_lines`
	-- 		},
	-- 	},
	-- },
	{
		import = "plugins.extras.editor.surround",
	},
	{
		"nvim-mini/mini.ai",
		event = "BufReadPost",
		opts = function()
			local ai = require("mini.ai")
			return {
				n_lines = 500,
				custom_textobjects = {
					o = ai.gen_spec.treesitter({ -- code block
						a = { "@block.outer", "@conditional.outer", "@loop.outer" },
						i = { "@block.inner", "@conditional.inner", "@loop.inner" },
					}),
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
					c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
					t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
					d = { "%f[%d]%d+" }, -- digits
					e = { -- Word with case
						{
							"%u[%l%d]+%f[^%l%d]",
							"%f[%S][%l%d]+%f[^%l%d]",
							"%f[%P][%l%d]+%f[^%l%d]",
							"^[%l%d]+%f[^%l%d]",
						},
						"^().*()$",
					},
					g = function(ai_type)
						local start_line, end_line = 1, vim.fn.line("$")
						if ai_type == "i" then
							-- Skip first and last blank lines for `i` textobject
							local first_nonblank, last_nonblank =
								vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
							-- Do nothing for buffer with all blanks
							if first_nonblank == 0 or last_nonblank == 0 then
								return { from = { line = start_line, col = 1 } }
							end
							start_line, end_line = first_nonblank, last_nonblank
						end

						local to_col = math.max(vim.fn.getline(end_line):len(), 1)
						return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
					end, -- buffer
					u = ai.gen_spec.function_call(), -- u for "Usage"
					U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
				},
			}
		end,
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		vscode = true,
		config = function()
			require("flash").setup({})
			function FlashWords()
				local Flash = require("flash")
				local function format(opts)
					-- always show first and second label
					return { { opts.match.label1, "FlashMatch" }, { opts.match.label2, "FlashLabel" } }
				end
				Flash.jump({
					search = {
						mode = "search",
					},
					label = {
						after = false,
						before = { 0, 0 },
						uppercase = false,
						format = format,
					},
					pattern = [[\<]],
					action = function(match, state)
						state:hide()
						Flash.jump({
							search = {
								max_length = 0,
							},
							highlight = {
								matches = false,
							},
							label = {
								format = format,
							},
							matcher = function(win)
								-- limit matches to the current label
								return vim.tbl_filter(function(m)
									return m.label == match.label and m.win == win
								end, state.results)
							end,
							labeler = function(matches)
								for _, m in ipairs(matches) do
									m.label = m.label2 -- use the second label
								end
							end,
						})
					end,
					labeler = function(matches, state)
						local labels = state:labels()
						for m, match in ipairs(matches) do
							match.label1 = labels[math.floor((m - 1) / #labels) + 1]
							match.label2 = labels[(m - 1) % #labels + 1]
							match.label = match.label1
						end
					end,
				})
			end

			function FlashLines()
				require("flash").jump({
					search = {
						mode = "search",
						max_length = 0,
					},
					label = {
						after = { 0, 0 },
					},
					pattern = "^",
				})
			end

			vim.keymap.set({ "o", "x", "n" }, "gw", FlashWords, {
				desc = "Flash Words",
			})
			vim.keymap.set({ "o", "x", "n" }, "gj", FlashLines, {
				desc = "Flash Lines",
			})
		end,
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Toggle Flash Search",
			},
		},
	},
	{
		"SCJangra/table-nvim",
		ft = "markdown",
		opts = {},
	},
	{
		"gbprod/yanky.nvim",
		event = "LazyFile",
		opts = {
			highlight = {
				timer = 150,
			},
		},
		keys = {
			-- {
			--     "<leader>p",
			--     function()
			--         vim.cmd([[YankyRingHistory]])
			--     end,
			--     mode = { "n", "x" },
			--     desc = "Open Yank History",
			-- },
			{
				"y",
				"<Plug>(YankyYank)",
				mode = { "n", "x" },
				desc = "Yank Text",
			},
			{
				"p",
				"<Plug>(YankyPutAfter)",
				mode = { "n", "x" },
				desc = "Put Text After Cursor",
			},
			{
				"P",
				"<Plug>(YankyPutBefore)",
				mode = { "n", "x" },
				desc = "Put Text Before Cursor",
			},
			{
				"gp",
				"<Plug>(YankyGPutAfter)",
				mode = { "n", "x" },
				desc = "Put Text After Selection",
			},
			{
				"gP",
				"<Plug>(YankyGPutBefore)",
				mode = { "n", "x" },
				desc = "Put Text Before Selection",
			},
			{
				"[y",
				"<Plug>(YankyCycleForward)",
				desc = "Cycle Forward Through Yank History",
			},
			{
				"]y",
				"<Plug>(YankyCycleBackward)",
				desc = "Cycle Backward Through Yank History",
			},
			{
				"]p",
				"<Plug>(YankyPutIndentAfterLinewise)",
				desc = "Put Indented After Cursor (Linewise)",
			},
			{
				"[p",
				"<Plug>(YankyPutIndentBeforeLinewise)",
				desc = "Put Indented Before Cursor (Linewise)",
			},
			{
				"]P",
				"<Plug>(YankyPutIndentAfterLinewise)",
				desc = "Put Indented After Cursor (Linewise)",
			},
			{
				"[P",
				"<Plug>(YankyPutIndentBeforeLinewise)",
				desc = "Put Indented Before Cursor (Linewise)",
			},
			{
				">p",
				"<Plug>(YankyPutIndentAfterShiftRight)",
				desc = "Put and Indent Right",
			},
			{
				"<p",
				"<Plug>(YankyPutIndentAfterShiftLeft)",
				desc = "Put and Indent Left",
			},
			{
				">P",
				"<Plug>(YankyPutIndentBeforeShiftRight)",
				desc = "Put Before and Indent Right",
			},
			{
				"<P",
				"<Plug>(YankyPutIndentBeforeShiftLeft)",
				desc = "Put Before and Indent Left",
			},
			{
				"=p",
				"<Plug>(YankyPutAfterFilter)",
				desc = "Put After Applying a Filter",
			},
			{
				"=P",
				"<Plug>(YankyPutBeforeFilter)",
				desc = "Put Before Applying a Filter",
			},
		},
	},
}
