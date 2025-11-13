local autocmd = vim.api.nvim_create_autocmd

-- auto save
autocmd({ "InsertLeave", "TextChanged" }, {
	pattern = { "*" },
	callback = function()
		if vim.b.buftype ~= "nofile" and vim.o.filetype ~= "oil" then
			vim.cmd("silent! wall")
		end
	end,
	nested = true,
})

-- auto make directory
autocmd({ "BufWritePre" }, {
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- ask to reload buffer if it was edited in other place
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
})

-- resume last position
autocmd("BufReadPost", {
	callback = function(event)
		local exclude = { "gitcommit" }
		local buf = event.buf
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].abalone_last_loc then
			return
		end
		vim.b[buf].abalone_last_loc = true
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

--
autocmd("FileType", {
	pattern = {
		"PlenaryTestPopup",
		"checkhealth",
		"dbout",
		"gitsigns-blame",
		"grug-far",
		"help",
		"lspinfo",
		"neotest-output",
		"neotest-output-panel",
		"neotest-summary",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"oil",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})

autocmd("FileType", {
	pattern = { "man" },
	callback = function(event)
		vim.bo[event.buf].buflisted = false
	end,
})
autocmd("FileType", {
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.spell = true
	end,
})
autocmd({ "FileType" }, {
	pattern = { "json", "jsonc", "json5" },
	callback = function()
		vim.opt_local.conceallevel = 0
	end,
})
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
	group = vim.api.nvim_create_augroup("NvimFilePost", { clear = true }),
	callback = function(args)
		local file = vim.api.nvim_buf_get_name(args.buf)
		local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

		if not vim.g.ui_entered and args.event == "UIEnter" then
			vim.g.ui_entered = true
		end

		if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
			vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
			vim.api.nvim_del_augroup_by_name("NvimFilePost")

			vim.schedule(function()
				vim.api.nvim_exec_autocmds("FileType", {})
			end)
		end
	end,
})

autocmd("LspAttach", {
	callback = function(args)
		vim.schedule(function()
			local client = vim.lsp.get_client_by_id(args.data.client_id)

			if client then
				local signatureProvider = client.server_capabilities.signatureHelpProvider
				if signatureProvider and signatureProvider.triggerCharacters then
					require("configs.lsp.signature").setup(client, args.buf)
				end
			end
		end)
	end,
})

local marks_fix_group = vim.api.nvim_create_augroup("marks-fix-hl", {})
vim.api.nvim_create_autocmd({ "VimEnter" }, {
	group = marks_fix_group,
	callback = function()
		vim.api.nvim_set_hl(0, "MarkSignNumHL", {})
	end,
})

vim.api.nvim_create_autocmd({ "UIEnter" }, {
	callback = function(event)
		local client = vim.api.nvim_get_chan_info(vim.v.event.chan).client
		if client ~= nil and client.name == "Firenvim" then
			vim.o.laststatus = 0
			vim.o.showtabline = 0
		end
	end,
})
