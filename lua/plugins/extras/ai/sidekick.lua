return {
	{
		"folke/sidekick.nvim",
		event = "User FilePost",
		opts = {
			-- add any options here
			cli = {
				layout = "left", ---@type "float"|"left"|"bottom"|"top"|"right"
				float = {
					width = 0.9,
					height = 0.9,
				},
				split = {
					width = 40,
					height = 20,
				},
				mux = {
					backend = "tmux",
					enabled = true,
				},
			},
		},
		config = function(_, opts)
			Abalone.cmp.actions.ai_nes = function()
				local Nes = require("sidekick.nes")
				if Nes.have() and (Nes.jump() or Nes.apply()) then
					return true
				end
			end
			require("sidekick").setup(opts)
		end,
		keys = {
			{
				"<tab>",
				Abalone.cmp.map({ "ai_nes" }, "<tab>"),
				mode = { "n" },
				expr = true,
			},
			{
				"<leader>ai",
				function()
					require("sidekick.cli").toggle()
				end,
				desc = "Sidekick Toggle CLI",
			},
			{
				"<leader>ag",
				function()
					require("sidekick.cli").select()
				end,
				-- Or to select only installed tools:
				-- require("sidekick.cli").select({ filter = { installed = true } })
				desc = "Select CLI",
			},
			{
				"<leader>aw",
				function()
					require("sidekick.cli").send({ msg = "{this}" })
				end,
				mode = { "x", "n" },
				desc = "Send This",
			},
			{
				"<leader>av",
				function()
					require("sidekick.cli").send({ msg = "{selection}" })
				end,
				mode = { "x" },
				desc = "Send Visual Selection",
			},
			{
				"<leader>ap",
				function()
					require("sidekick.cli").prompt()
				end,
				mode = { "n", "x" },
				desc = "Sidekick Select Prompt",
			},
			{
				"<c-.>",
				function()
					require("sidekick.cli").focus()
				end,
				mode = { "n", "x", "i", "t" },
				desc = "Sidekick Switch Focus",
			},
			-- Example of a keybinding to open Claude directly
			-- {
			--     "<leader>ac",
			--     function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
			--     desc = "Sidekick Claude Toggle",
			--     mode = { "n", "v" },
			-- },
		},
	},
}
