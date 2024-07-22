local ts_context_commentstring = {
  "JoosepAlviste/nvim-ts-context-commentstring",
  lazy = true,
  opts = {
    enable_autocmd = false,
  },
}

local comment = {
  "numToStr/Comment.nvim",

  opts = function()
    return {
      mappings = false,
      pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
    }
  end,

  keys = {
    {
      "<leader>/",
      function()
        require("Comment.api").toggle.linewise.current()
      end,
      desc = "Comment",
    },
    {
      "<leader>/",
      '<esc><cmd>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<cr>',
      mode = "v",
      desc = "Comment",
    },
  },
}

return {
  ts_context_commentstring,
  comment,
}
