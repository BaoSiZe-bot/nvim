-- This file is automatically loaded by plugins.core
local opt = vim.opt
opt.autowrite = true -- Enable auto write
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
vim.g.neominimap = {
  auto_enable = true,
}
vim.g.lazyvim_picker = "auto"
vim.g.markdown_recommended_style = 0
vim.wo.colorcolumn = "80"
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.guifont = "VictorMono Nerd Font:h14"
if vim.g.neovide == true then
  vim.g.neovide_transparency = 0.8
  vim.g.neovide_cursor_vfx_mode = "ripple"
  vim.g.neovide_input_ime = 0
end
