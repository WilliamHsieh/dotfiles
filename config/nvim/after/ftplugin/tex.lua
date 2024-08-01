vim.opt_local.wrap = true
vim.opt_local.spell = true
vim.opt_local.linebreak = true
vim.opt_local.conceallevel = 1
vim.g.tex_conceal = 'abdmg'

-- mappings
vim.keymap.set({ "n", "v" }, "j", "gj")
vim.keymap.set({ "n", "v" }, "k", "gk")

local ok, wk = pcall(require, "which-key")
if ok then
  wk.register {
    ["<leader>v"] = { name = "Vimtex" },
  }
end

vim.api.nvim_create_autocmd("User", {
  pattern = "VimtexEventViewReverse",
  callback = function()
    vim.api.nvim_create_autocmd("FocusGained", {
      pattern = "*",
      once = true,
      callback = function()
        vim.defer_fn(function()
          vim.cmd.normal("yy")
        end, 100)
      end
    })
  end
})

vim.cmd.TSContextDisable()
