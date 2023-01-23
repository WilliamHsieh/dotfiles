local M = {
  "vimpostor/vim-tpipeline",
}

function M.config()
  vim.g.tpipeline_cursormoved = 1
  vim.g.tpipeline_restore = 1
  vim.g.tpipeline_clearstl = 1
  if vim.env.TMUX then
    vim.api.nvim_create_autocmd({ 'DiagnosticChanged', "RecordingEnter" }, {
      desc = "update tpipeline",
      command = "call tpipeline#update()"
    })
  end
end

return M
