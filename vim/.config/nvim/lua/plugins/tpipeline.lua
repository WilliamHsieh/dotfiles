local M = {
  "vimpostor/vim-tpipeline",
}

function M.config()
  vim.g.tpipeline_cursormoved = 1
  vim.g.tpipeline_restore = 1
  vim.g.tpipeline_clearstl = 1
  if vim.env.TMUX then
    vim.api.nvim_create_autocmd('DiagnosticChanged', {
      desc = "update tpipeline",
      command = "call tpipeline#update()"
    })
  end
  -- FIX: lua api
  vim.cmd [[
    au User MatchupOffscreenEnter let g:sl = g:tpipeline_statusline | let g:tpipeline_statusline = &l:stl
    au User MatchupOffscreenLeave let g:tpipeline_statusline = g:sl
  ]]
end

return M
