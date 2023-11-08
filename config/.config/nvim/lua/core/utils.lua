local utils = {}

-- show all highlight groups by sourcing $VIMRUNTIME/syntax/hitest.vim
function utils.get_hl(group)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = true })
  local function to_hex(color)
    return color and string.format("#%06x", color) or ''
  end
  return { fg = to_hex(hl.fg), bg = to_hex(hl.bg) }
end

function utils.get_tmux_option(opt)
  return vim.fn.system { "tmux", "show-options", "-Av", opt }
end

local tmux_is_active = nil

function utils.is_tmux_active()
  if tmux_is_active == nil then
    tmux_is_active = vim.env.TMUX ~= nil and utils.get_tmux_option("status"):find("^on") ~= nil
  end
  return tmux_is_active
end

return utils
