return {
	{
		"yetone/avante.nvim",
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		-- ⚠️ must add this setting! ! !
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = {
			---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
			---@type Provider
			provider = "gemini-cli", -- The provider used in Aider mode or in the planning phase of Cursor Planning Mode
			---@alias Mode "agentic" | "legacy"
			---@type Mode
			mode = "agentic", -- The default mode for interaction. "agentic" uses tools to automatically generate code, "legacy" uses the old planning method to generate code.
			-- WARNING: Since auto-suggestions are a high-frequency operation and therefore expensive,
			-- currently designating it as `copilot` provider is dangerous because: https://github.com/yetone/avante.nvim/issues/1048
			-- Of course, you can reduce the request frequency by increasing `suggestion.debounce`.
			auto_suggestions_provider = "gemini",
			acp_providers = {
				["gemini-cli"] = {
					command = "gemini",
					args = { "--experimental-acp" },
					env = {
						NODE_NO_WARNINGS = "1",
						GEMINI_API_KEY = os.getenv("AVANTE_GEMINI_API_KEY"),
					},
				},
				["claude-code"] = {
					command = "npx",
					args = { "@zed-industries/claude-code-acp" },
					env = {
						NODE_NO_WARNINGS = "1",
						ANTHROPIC_API_KEY = os.getenv("AVANTE_ANTHROPIC_API_KEY"),
					},
				},
			},
			providers = {
				morph = {
					model = "auto",
				},
				deepseek = {
					__inherited_from = "openai",
					api_key_name = "DEEPSEEK_API_KEY",
					endpoint = "https://api.deepseek.com",
					model = "deepseek-coder",
				},
				mistral = {
					__inherited_from = "openai",
					api_key_name = "MISTRAL_API_KEY",
					endpoint = "https://api.mistral.ai/v1/",
					model = "mistral-large-latest",
					extra_request_body = {
						max_tokens = 4096, -- to avoid using max_completion_tokens
					},
				},
				-- claude = {
				-- 	endpoint = "https://api.anthropic.com",
				-- 	model = "claude-3-5-sonnet-20241022",
				-- 	extra_request_body = {
				-- 		temperature = 0.75,
				-- 		max_tokens = 4096,
				-- 	},
				-- },
			},
			---Specify the special dual_boost mode
			---1. enabled: Whether to enable dual_boost mode. Default to false.
			---2. first_provider: The first provider to generate response. Default to "openai".
			---3. second_provider: The second provider to generate response. Default to "claude".
			---4. prompt: The prompt to generate response based on the two reference outputs.
			---5. timeout: Timeout in milliseconds. Default to 60000.
			---How it works:
			--- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
			---Note: This is an experimental feature and may not work as expected.
			dual_boost = {
				enabled = false,
				first_provider = "gemini",
				second_provider = "claude",
				prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
				timeout = 60000, -- Timeout in milliseconds
			},
			behaviour = {
				enable_fastapply = true, -- Enable Fast Apply feature
				auto_suggestions = false, -- Experimental stage
				auto_set_highlight_group = true,
				auto_set_keymaps = true,
				auto_apply_diff_after_generation = false,
				support_paste_from_clipboard = false,
				minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
				enable_token_counting = true, -- Whether to enable token counting. Default to true.
				auto_add_current_file = true, -- Whether to automatically add the current file when opening a new chat. Default to true.
				auto_approve_tool_permissions = true, -- Default: auto-approve all tools (no prompts)
				-- Examples:
				-- auto_approve_tool_permissions = false,                -- Show permission prompts for all tools
				-- auto_approve_tool_permissions = {"bash", "replace_in_file"}, -- Auto-approve specific tools only
			},
			prompt_logger = { -- logs prompts to disk (timestamped, for replay/debugging)
				enabled = true, -- toggle logging entirely
				log_dir = vim.fn.stdpath("cache") .. "/avante_prompts", -- directory where logs are saved
				fortune_cookie_on_success = false, -- shows a random fortune after each logged prompt (requires `fortune` installed)
				next_prompt = {
					normal = "<C-n>", -- load the next (newer) prompt log in normal mode
					insert = "<C-n>",
				},
				prev_prompt = {
					normal = "<C-p>", -- load the previous (older) prompt log in normal mode
					insert = "<C-p>",
				},
			},
			mappings = {
				--- @class AvanteConflictMappings
				diff = {
					ours = "co",
					theirs = "ct",
					all_theirs = "ca",
					both = "cb",
					cursor = "cc",
					next = "]x",
					prev = "[x",
				},
				suggestion = {
					accept = "<M-l>",
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
				jump = {
					next = "]]",
					prev = "[[",
				},
				submit = {
					normal = "<CR>",
					insert = "<C-s>",
				},
				cancel = {
					normal = { "<C-c>", "<Esc>", "q" },
					insert = { "<C-c>" },
				},
				sidebar = {
					apply_all = "A",
					apply_cursor = "a",
					retry_user_request = "r",
					edit_user_request = "e",
					switch_windows = "<Tab>",
					reverse_switch_windows = "<S-Tab>",
					remove_file = "d",
					add_file = "@",
					close = { "<Esc>", "q" },
					close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
				},
			},
			selection = {
				enabled = true,
				hint_display = "delayed",
			},
			input = {
				provider = "snacks",
				provider_opts = {
					-- Additional snacks.input options
					title = "Avante Input",
					icon = " ",
				},
			},
			windows = {
				---@type "right" | "left" | "top" | "bottom"
				position = "right", -- the position of the sidebar
				wrap = true, -- similar to vim.o.wrap
				width = 30, -- default % based on available width
				sidebar_header = {
					enabled = true, -- true, false to enable/disable the header
					align = "center", -- left, center, right for title
					rounded = true,
				},
				spinner = {
					editing = {
						"⡀",
						"⠄",
						"⠂",
						"⠁",
						"⠈",
						"⠐",
						"⠠",
						"⢀",
						"⣀",
						"⢄",
						"⢂",
						"⢁",
						"⢈",
						"⢐",
						"⢠",
						"⣠",
						"⢤",
						"⢢",
						"⢡",
						"⢨",
						"⢰",
						"⣰",
						"⢴",
						"⢲",
						"⢱",
						"⢸",
						"⣸",
						"⢼",
						"⢺",
						"⢹",
						"⣹",
						"⢽",
						"⢻",
						"⣻",
						"⢿",
						"⣿",
					},
					generating = { "·", "✢", "✳", "∗", "✻", "✽" }, -- Spinner characters for the 'generating' state
					thinking = { "🤯", "🙄" }, -- Spinner characters for the 'thinking' state
				},
				input = {
					prefix = "> ",
					height = 8, -- Height of the input window in vertical layout
				},
				edit = {
					border = "rounded",
					start_insert = true, -- Start insert mode when opening the edit window
				},
				ask = {
					floating = false, -- Open the 'AvanteAsk' prompt in a floating window
					start_insert = true, -- Start insert mode when opening the ask window
					border = "rounded",
					---@type "ours" | "theirs"
					focus_on_apply = "ours", -- which diff to focus after applying
				},
			},
			highlights = {
				---@type AvanteConflictHighlights
				diff = {
					current = "DiffText",
					incoming = "DiffAdd",
				},
			},
			selector = {
				--- @alias avante.SelectorProvider "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope" | fun(selector: avante.ui.Selector): nil
				--- @type avante.SelectorProvider
				provider = "snacks",
				-- Options override for custom providers
				provider_opts = {},
			},
			--- @class AvanteConflictUserConfig
			diff = {
				autojump = true,
				---@type string | fun(): any
				list_opener = "copen",
				--- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
				--- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
				--- Disable by setting to -1.
				override_timeoutlen = 500,
			},
			suggestion = {
				debounce = 600,
				throttle = 600,
			},
		},
		config = function(_, opts)
			require("avante").setup(opts)
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"folke/snacks.nvim", -- for input provider snacks
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
		},
	},

	{
		"saghen/blink.cmp",
		optional = true,
		dependencies = {
			"Kaiser-Yang/blink-cmp-avante",
		},
		opts = function(_, opts)
			opts.sources.default = opts.sources.default or {}
			table.insert(opts.sources.default, "avante")

			opts.sources.providers = opts.sources.providers or {}
			opts.sources.providers.avante = {
				module = "blink-cmp-avante",
				name = "Avante",
				opts = {
					-- options for blink-cmp-avante
				},
			}

			return opts
		end,
	},
}
