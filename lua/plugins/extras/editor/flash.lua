return {
	"folke/flash.nvim",
	event = "VeryLazy",
	vscode = true,
	opts = {
		modes = {
			char = {
				keys = { "f", "F", "t", "T" },
				char_actions = function(motion)
					return {
						-- clever-f style
						-- [motion:lower()] = "next",
						-- [motion:upper()] = "prev",
						-- jump2d style: same case goes next, opposite case goes prev
						[motion] = "next",
						[motion:match("%l") and motion:upper() or motion:lower()] = "prev",
					}
				end,
			},
		},
	},
	config = function(_, opts)
		require("flash").setup(opts)
		function FlashWords()
			local Flash = require("flash")

			local function format(opt)
				-- always show first and second label
				return {
					{ opt.match.label1, "FlashMatch" },
					{ opt.match.label2, "FlashLabel" },
				}
			end

			Flash.jump({
				search = { mode = "search" },
				label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
				pattern = [[\<]],
				action = function(match, state)
					state:hide()
					Flash.jump({
						search = { max_length = 0 },
						highlight = { matches = false },
						label = { format = format },
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
				search = { mode = "search", max_length = 0 },
				label = { after = { 0, 0 } },
				pattern = "^",
			})
		end

		vim.keymap.set({ "o", "x", "n" }, "gw", FlashWords, { desc = "Flash Words" })
		vim.keymap.set({ "o", "x", "n" }, "gj", FlashLines, { desc = "Flash Lines" })
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
}
