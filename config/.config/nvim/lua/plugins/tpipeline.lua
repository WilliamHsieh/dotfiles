local M = {
  "vimpostor/vim-tpipeline",
  cond = vim.env.TMUX ~= nil
}

function M.init()
  vim.g.tpipeline_cursormoved = 1
  vim.g.tpipeline_restore = 1
  vim.g.tpipeline_clearstl = 1
  vim.g.tpipeline_size = 300
end

function M.config()
  -- update statusline
  vim.api.nvim_create_autocmd({ 'DiagnosticChanged', "RecordingEnter" }, {
    desc = "update tpipeline",
    command = "call tpipeline#update()"
  })

  -- update statusline on vim-matchup
  vim.api.nvim_create_autocmd("User", {
    pattern = "MatchupOffscreenEnter",
    callback = function()
      if not string.find(vim.g.tpipeline_statusline, "matchup") then
        vim.g.sl = vim.g.tpipeline_statusline
      end
      if string.find(vim.o.stl, "matchup") then
        vim.g.tpipeline_statusline = vim.o.stl
      end
      vim.fn["tpipeline#update"]()
    end
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = "MatchupOffscreenLeave",
    callback = function()
      vim.g.tpipeline_statusline = vim.g.sl
      vim.fn["tpipeline#update"]()
    end
  })
end

return M
