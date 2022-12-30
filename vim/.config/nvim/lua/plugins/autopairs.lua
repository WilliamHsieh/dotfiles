local M = {
  "windwp/nvim-autopairs",
  event = "VeryLazy"
}

function M.config()
  require("nvim-autopairs").setup {
    check_ts = true,
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    fast_wrap = {
      map = "<C-l>",
      chars = { "{", "[", "(", "<", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0, -- Offset from pattern match
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
    pairs_map = { -- FIX: not working
      ['<'] = '>',
    }
  }
end

return M