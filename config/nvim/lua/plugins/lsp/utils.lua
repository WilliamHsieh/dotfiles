local M = {}

-- auto detach LSP after timeout
M.setup_auto_detach = function()
  vim.api.nvim_create_autocmd("LspAttach", {
    once = true,
    callback = function()
      local lsp_detach_group = vim.api.nvim_create_augroup("lsp_detach", { clear = true })
      local timer = vim.loop.new_timer()
      local timeout = 1000 * 60 * 60 * 24

      vim.api.nvim_create_autocmd("FocusLost", {
        group = lsp_detach_group,
        callback = function()
          timer:start(
            timeout,
            0,
            vim.schedule_wrap(function()
              pcall(vim.cmd.LspStop)
            end)
          )
        end,
      })

      vim.api.nvim_create_autocmd("FocusGained", {
        group = lsp_detach_group,
        callback = function()
          if not timer:is_active() then
            pcall(vim.cmd.LspStart)
            vim.cmd("Lazy reload lazydev.nvim")
            if not vim.g.copilot_disabled then
              require("copilot.command").enable()
            end
          end
          timer:stop()
        end,
      })
    end,
  })
end

return M
