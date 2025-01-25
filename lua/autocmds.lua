-- [nfnl] Compiled from fnl/autocmds.fnl by https://github.com/Olical/nfnl, do not edit.
do
  local autocmd = vim.api.nvim_create_autocmd
  autocmd({"InsertLeave", "TextChanged"}, {pattern = {"*"}, command = "silent! wall", nested = true})
  local function _1_(args)
    _G.assert((nil ~= args), "Missing argument args on /home/bszzz/.config/nvim/fnl/autocmds.fnl:6")
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", {buf = args.buf})
    if (not vim.g.ui_entered and (args.event == "UIEnter")) then
      vim.g.ui_entered = true
    else
    end
    if (not (file == "") and not (buftype == "nofile") and vim.g.ui_entered) then
      vim.api.nvim_exec_autocmds("User", {pattern = "FilePost", modeline = false})
      vim.api.nvim_del_augroup_by_name("NvFilePost")
      local function _3_()
        vim.api.nvim_exec_autocmds("FileType", {})
        if vim.g.editorconfig then
          local _, editorconf = pcall(require, "editorconfig")
          return editorconf.config(args.buf)
        else
          return nil
        end
      end
      return vim.schedule(_3_)
    else
      return nil
    end
  end
  autocmd({"UIEnter", "BufReadPost", "BufNewFile"}, {group = vim.api.nvim_create_augroup("NvFilePost", {clear = true}), callback = _1_})
end
return nil
