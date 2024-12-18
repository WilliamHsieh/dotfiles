return {
  "Bekaboo/dropbar.nvim",
  event = "LazyFile",

  ---@type dropbar_configs_t
  opts = {
    bar = {
      enable = function(buf, win, _)
        -- enable even if the treesitter parser is not available
        return vim.api.nvim_buf_is_valid(buf)
          and vim.api.nvim_win_is_valid(win)
          and vim.wo[win].winbar == ""
          and vim.fn.win_gettype(win) == ""
          and vim.bo[buf].ft ~= "help"
      end,
      pick = {
        pivots = "asdfghjkl;qwertyuiopzxcvbnm",
      },
      sources = function()
        return {
          {
            get_symbols = function(buff, win, cursor)
              local symbols = require("dropbar.sources").path.get_symbols(buff, win, cursor)
              if vim.bo[buff].modified then
                symbols[#symbols].name = symbols[#symbols].name .. " [+]"
              end
              return symbols
            end,
          },
        }
      end,
    },
  },
}
