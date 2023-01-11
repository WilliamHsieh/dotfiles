local M = {
  "mbbill/undotree",
}

local function undotree()
  local tmp = vim.g.tpipeline_statusline
  if tmp:find("undotree") then return end
  vim.cmd.UndotreeToggle()
  vim.api.nvim_create_autocmd("BufUnload", {
    pattern = "<buffer>",
    once = true,
    callback = function()
      vim.g.tpipeline_statusline = tmp
    end
  })
end

M.config = function()
  vim.g.undotree_WindowLayout = 4
  vim.g.undotree_SetFocusWhenToggle = 4
end

M.keys = {
  { "<leader>bu", undotree, desc = "Undo tree" }
}

return M
