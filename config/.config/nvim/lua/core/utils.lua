local utils = {}

-- show all highlight groups by sourcing $VIMRUNTIME/syntax/hitest.vim
function utils.get_hl(group)
  local hl = vim.api.nvim_get_hl_by_name(group, true)
  local function to_hex(color)
    return color and string.format("#%06x", color) or ''
  end
  return { fg = to_hex(hl.foreground), bg = to_hex(hl.background) }
end

return utils
