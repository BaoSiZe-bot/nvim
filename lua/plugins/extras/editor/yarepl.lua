return {
	"milanglacier/yarepl.nvim",
	keys = {
		{ "<leader>or", "<Plug>(REPLStart)", noremap = false, mode = "n", desc = "Start REPL" },
		{
			"<leader>os",
			function()
				require("yarepl.extensions.snacks").repl_show({
					prompt = "Yarepl REPL",
				})
			end,
			noremap = false,
			mode = "n",
			desc = "Search REPL",
		},
	},
	opts = function()
		local yarepl = require("yarepl")
		return {
			-- see `:h buflisted`, whether the REPL buffer should be buflisted.
			buflisted = true,
			-- whether the REPL buffer should be a scratch buffer.
			scratch = true,
			-- the filetype of the REPL buffer created by `yarepl`
			ft = "REPL",
			-- How yarepl open the REPL window, can be a string or a lua function.
			-- See below example for how to configure this option
			wincmd = "belowright 15 split",
			-- The available REPL palattes that `yarepl` can create REPL based on.
			-- To disable a built-in meta, set its key to `false`, e.g., `metas = { R = false }`
			metas = {
				aichat = { cmd = "aichat", formatter = "bracketed_pasting", source_syntax = "aichat" },
				radian = { cmd = "radian", formatter = "bracketed_pasting_no_final_new_line", source_syntax = "R" },
				ipy_tmux = {
					cmd = "tmux attach -t ipython || tmux new -s ipython ipython",
					formatter = yarepl.formatter.bracketed_pasting,
				},
				igcc = { cmd = "igcc", formatter = "bracketed_pasting", source_syntax = "ipython" },
				python = { cmd = "python", formatter = "trim_empty_lines", source_syntax = "python" },
				R = { cmd = "R", formatter = "trim_empty_lines", source_syntax = "R" },
				bash = {
					cmd = "bash",
					formatter = vim.fn.has("linux") == 1 and "bracketed_pasting" or "trim_empty_lines",
					source_syntax = "bash",
				},
				zsh = { cmd = "zsh", formatter = "bracketed_pasting", source_syntax = "bash" },
			},
			-- when a REPL process exits, should the window associated with those REPLs closed?
			close_on_exit = true,
			-- whether automatically scroll to the bottom of the REPL window after sending
			-- text? This feature would be helpful if you want to ensure that your view
			-- stays updated with the latest REPL output.
			scroll_to_bottom_after_sending = true,
			-- Format REPL buffer names as #repl_name#n (e.g., #ipython#1) instead of using terminal defaults
			format_repl_buffers_names = true,
			os = {
				-- Some hacks for Windows. macOS and Linux users can simply ignore
				-- them. The default options are recommended for Windows user.
				windows = {
					-- Send a final `\r` to the REPL with delay,
					send_delayed_final_cr = true,
				},
			},
			-- Display the first line as virtual text to indicate the actual
			-- command sent to the REPL.
			source_command_hint = {
				enabled = false,
				hl_group = "Comment",
			},
		}
	end,
}
