local utils = {}

function utils.insert_table(ts)
  return function(t)
    table.insert(ts, t)
  end
end

function utils.get_hl(group)
  local hl = vim.api.nvim_get_hl_by_name(group, true)
  local function to_hex(color)
    return color and string.format("#%06x", color) or ''
  end
  return { fg = to_hex(hl.foreground), bg = to_hex(hl.background) }
end


return utils
