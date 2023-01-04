vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.linebreak = true
vim.opt_local.conceallevel = 1
vim.g.tex_conceal = 'abdmg'

-- mappings
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

local ok, wk = pcall(require, "which-key")
if ok then
  wk.register {
    ["<leader>v"] = { name = "Vimtex" },
  }
end

vim.cmd.TSContextDisable()
