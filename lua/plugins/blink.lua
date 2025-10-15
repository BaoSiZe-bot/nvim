return {
	{
		"saghen/blink.cmp",
		build = "cargo build --release",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.compat",
			"sources.default",
		},
		dependencies = {
			"rafamadriz/friendly-snippets",
			"rcarriga/cmp-dap",
		},
		event = { "LspAttach", "CmdlineEnter" },
		---@module 'blink.cmp'
		opts = function(_, opts)
			local config = {
				snippets = {
					expand = function(snippet, _)
						return Abalone.cmp.expand(snippet)
					end,
				},
				appearance = {
					use_nvim_cmp_as_default = false,
					nerd_font_variant = "mono",
				},
				completion = {
					accept = {
						auto_brackets = {
							enabled = true,
						},
					},
					menu = {
						border = "none",
						-- border = "rounded",
						-- enabled = true,
						-- scrollbar = false
						-- auto_show = true,
						draw = {
							treesitter = { "lsp" },
							padding = { 0, 1 },
							columns = { { "kind_icon" }, { "label" }, { "kind" } },
							components = {
								kind_icon = {
									text = function(ctx)
										local icons = vim.tbl_extend("force", {}, Abalone.icons.kinds)
										local icon = (icons[ctx.kind] or "󰈚")
										icon = " " .. icon .. " "
										return icon
									end,
								},

								kind = {
									highlight = function(ctx)
										return "comment"
									end,
								},

								label = {
									highlight = function(ctx)
										-- label and label details
										ctx.label = ctx.label .. ctx.label_detail
										ctx.label_detail = ""
										local label = ctx.label
										local highlights = {
											{
												0,
												#label,
												group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
											},
										}

										if
											vim.list_contains(ctx.self.treesitter, ctx.source_id) and not ctx.deprecated
										then
											-- add treesitter highlights
											vim.list_extend(
												highlights,
												require("blink.cmp.completion.windows.render.treesitter").highlight(ctx)
											)
										end

										-- characters matched on the label by the fuzzy matcher
										for _, idx in ipairs(ctx.label_matched_indices) do
											table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
										end

										return highlights
									end,
									-- text = function(ctx)
									--     return require("colorful-menu").blink_components_text(ctx)
									-- end,
									-- highlight = function(ctx)
									--     return require("colorful-menu").blink_components_highlight(ctx)
									-- end,
								},
							},
						},
					},
					-- keyword = {
					--     range = "prefix",
					--     regex = "[_,:\\?!]\\|[A-Za-z0-9]",
					-- },
					list = {
						selection = {
							preselect = true,
							auto_insert = true,
						},
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 200,
						window = {
							-- border = "single",
						},
					},
					ghost_text = {
						enabled = true,
					},
				},
				-- signature = { enabled = true }, -- have other plugin instead.
				sources = {
					default = {
						"lsp",
						"path",
						"snippets",
						"buffer",
						"markdown",
						--, "minuet",
					},
					per_filetype = {
						typst = { inherit_defaults = true, "dictionary" },
						markdown = { inherit_defaults = true, "dictionary" },
						text = { inherit_defaults = true, "dictionary" },
						["dap-repl"] = { inherit_defaults = true, "dap" },
						["dapui_hover"] = { inherit_defaults = true, "dap" },
						["dapui_watches"] = { inherit_defaults = true, "dap" },
					},
					providers = {
						lsp = {
							enabled = true,
							transform_items = function(_, items)
								for _, item in ipairs(items) do
									if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
										item.score_offset = item.score_offset - 3
									end
								end
								return items
							end,
						},
						dictionary = {
							module = "blink-cmp-dictionary",
							min_keyword_length = 3,
							opts = {
								dictionary_files = { vim.fn.expand("~/.config/nvim/lua/dict.txt") },
							},
						},
						markdown = {
							name = "RenderMarkdown",
							module = "render-markdown.integ.blink",
							fallbacks = { "lsp" },
						},
						dap = {
							name = "dap",
							module = "blink.compat.source",
							score_offset = -3,
						},
					},
				},
				cmdline = {
					enabled = true,
					keymap = { preset = "cmdline" },
					completion = {
						list = { selection = { preselect = false } },
						menu = {
							auto_show = function(_)
								return vim.fn.getcmdtype() == ":"
							end,
						},
						ghost_text = { enabled = true },
					},
				},
				term = {
					enabled = true,
					-- enabled = false,
					keymap = { preset = "super-tab" }, -- Inherits from top level `keymap` config when not set
					sources = {},
					completion = {
						trigger = {
							show_on_blocked_trigger_characters = {},
							show_on_x_blocked_trigger_characters = nil, -- Inherits from top level `completion.trigger.show_on_blocked_trigger_characters` config when not set
						},
						-- Inherits from top level config options when not set
						list = {
							selection = {
								-- When `true`, will automatically select the first item in the completion list
								preselect = true,
								-- When `true`, inserts the completion item automatically when selecting it
								auto_insert = true,
							},
						},
						-- Whether to automatically show the window when new completion items are available
						menu = { auto_show = true },
						-- Displays a preview of the selected item on the current line
						ghost_text = { enabled = true },
					},
				},
				keymap = {
					preset = "enter",
					["<C-y>"] = { "select_and_accept" },
					-- ["<C-S-y>"] = require('minuet').make_blink_map(),
				},
			}
			opts = vim.tbl_deep_extend("force", opts, config)
			if not opts.keymap["<Tab>"] then
				if opts.keymap.preset == "super-tab" then -- super-tab
					opts.keymap["<Tab>"] = {
						require("blink.cmp.keymap.presets").get("super-tab")["<Tab>"][1],
						Abalone.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
						"fallback",
					}
				else -- other presets
					opts.keymap["<Tab>"] = {
						Abalone.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
						"fallback",
					}
				end
			end
			return opts
		end,
	},
	{
		"saghen/blink.compat",
		opts = {},
	},
}
