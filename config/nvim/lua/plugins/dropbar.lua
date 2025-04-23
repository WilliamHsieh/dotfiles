local custom_path = {
  get_symbols = function(buff, win, cursor)
    local sources = require("dropbar.sources")
    local symbols = sources.path.get_symbols(buff, win, cursor)
    local tail = symbols[#symbols]

    tail.name_hl = "DropBarFileName"
    if vim.bo[buff].modified then
      tail.name = tail.name .. " [+]"
      tail.icon = " "
      tail.icon_hl = "diffNewFile"
    end

    return symbols
  end,
}

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

      ---@type dropbar_source_t[]|fun(buf: integer, win: integer): dropbar_source_t[]
      sources = function(buf, _)
        local sources = require("dropbar.sources")
        local utils = require("dropbar.utils")

        if vim.bo[buf].buftype == "terminal" then
          return {
            sources.terminal,
          }
        end

        if vim.bo[buf].ft == "markdown" then
          return {
            custom_path,
            sources.markdown,
          }
        end
        return {
          custom_path,
          utils.source.fallback {
            sources.lsp,
            sources.treesitter,
          },
        }
      end,
    },
  },
}
