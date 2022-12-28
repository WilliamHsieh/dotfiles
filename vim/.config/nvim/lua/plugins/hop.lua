local M = {
  "phaazon/hop.nvim",
  cmd = { 'HopChar2', 'HopWord' },
}

function M.config()
  require('hop').setup {
    -- keys = 'asdghklqwertyuiopzxcvbnmfj' -- default
    keys = 'awefjio;sdghklqrtyupvbn'
  }
end

return M
