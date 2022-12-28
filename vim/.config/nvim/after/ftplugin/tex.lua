vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.linebreak = true
vim.opt_local.conceallevel = 1
vim.opt_local.cmdheight = 1
vim.g.tex_conceal = 'abdmg'
-- vim.g.vimtex_mappings_enabled = 0

-- mappings
vim.keymap.set("n", "<leader>vv", "<cmd>VimtexView<cr>")
vim.keymap.set("n", "<leader>vc", "<cmd>VimtexCompile<cr>")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

local ok, wk = pcall(require, "which-key")
if ok then
  wk.register {
    ["<leader>v"] = { name = "Vimtex" },
    ["<localleader>"] = { name = "LocalLeader" },
    ["<localleader>l"] = { name = "Vimtex" },
  }
end

vim.cmd.TSContextDisable()
