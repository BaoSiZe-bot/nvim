local M = {}
local function sign_in(bufnr, client)
	client:request(
		---@diagnostic disable-next-line: param-type-mismatch
		"signIn",
		vim.empty_dict(),
		function(err, result)
			if err then
				vim.notify(err.message, vim.log.levels.ERROR)
				return
			end
			if result.command then
				local code = result.userCode
				local command = result.command
				vim.fn.setreg("+", code)
				vim.fn.setreg("*", code)
				local continue = vim.fn.confirm(
					"Copied your one-time code to clipboard.\n" .. "Open the browser to complete the sign-in process?",
					"&Yes\n&No"
				)
				if continue == 1 then
					client:exec_cmd(command, { bufnr = bufnr }, function(cmd_err, cmd_result)
						if cmd_err then
							vim.notify(err.message, vim.log.levels.ERROR)
							return
						end
						if cmd_result.status == "OK" then
							vim.notify("Signed in as " .. cmd_result.user .. ".")
						end
					end)
				end
			end

			if result.status == "PromptUserDeviceFlow" then
				vim.notify("Enter your one-time code " .. result.userCode .. " in " .. result.verificationUri)
			elseif result.status == "AlreadySignedIn" then
				vim.notify("Already signed in as " .. result.user .. ".")
			end
		end
	)
end

---@param client vim.lsp.Client
local function sign_out(_, client)
	client:request(
		---@diagnostic disable-next-line: param-type-mismatch
		"signOut",
		vim.empty_dict(),
		function(err, result)
			if err then
				vim.notify(err.message, vim.log.levels.ERROR)
				return
			end
			if result.status == "NotSignedIn" then
				vim.notify("Not signed in.")
			end
		end
	)
end
local on_attach = function(client, bufnr)
	local map = vim.keymap.set
	map({ "i", "n" }, "<M-]", function()
		vim.lsp.inline_completion.select({ count = 1 })
	end, { desc = "Next Copilot Suggestion", buffer = bufnr })
	map({ "i", "n" }, "<M-[", function()
		vim.lsp.inline_completion.select({ count = -1 })
	end, { desc = "Prev Copilot Suggestion", buffer = bufnr })
	vim.api.nvim_buf_create_user_command(bufnr, "LspCopilotSignIn", function()
		sign_in(bufnr, client)
	end, { desc = "Sign in Copilot with GitHub" })
	vim.api.nvim_buf_create_user_command(bufnr, "LspCopilotSignOut", function()
		sign_out(bufnr, client)
	end, { desc = "Sign out Copilot with GitHub" })
end

M.setup = function()
	vim.schedule(function()
		vim.lsp.inline_completion.enable()
	end)

	-- Accept inline suggestions or next edits
	Abalone.cmp.actions.ai_accept = function()
		return vim.lsp.inline_completion.get()
	end

	vim.lsp.config("copilot", {
		on_attach = on_attach,
		capabilities = Abalone.lsp._capabilities,
	})

	if not Abalone.lazy.has_extra("ai.sidekick") then
		vim.lsp.config("copilot", {
			handlers = {
				didChangeStatus = function(err, res, ctx)
					if err then
						return
					end
					if res.status == "Error" then
						error("Please use `:LspCopilotSignIn` to sign in to Copilot")
					end
				end,
			},
		})
	end
	vim.lsp.enable("copilot")
end

return M
