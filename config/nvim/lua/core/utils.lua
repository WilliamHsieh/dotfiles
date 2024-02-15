local M = {}

-- show all highlight groups by sourcing $VIMRUNTIME/syntax/hitest.vim
---get foreground and background from highlight group
---@param group string
---@return {fg:string, bg:string}
function M.get_hl(group)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = true })
  local function to_hex(color)
    return color and string.format("#%06x", color) or ''
  end
  return { fg = to_hex(hl.fg), bg = to_hex(hl.bg) }
end

---get tmux option
---@param opt string
---@return string?
function M.get_tmux_option(opt)
  return vim.fn.system { "tmux", "show-options", "-Av", opt }
end

local tmux_is_active = nil

function M.is_tmux_active()
  if tmux_is_active == nil then
    tmux_is_active = vim.env.TMUX ~= nil and M.get_tmux_option("status"):find("^on") ~= nil or false
  end
  return tmux_is_active
end

---function callback on plugin load
---https://github.com/LazyVim/LazyVim/blob/68ff818a5bb7549f90b05e412b76fe448f605ffb/lua/lazyvim/util/init.lua#L129
---@param name string
---@param fn function
function M.on_load(name, fn)
  local Config = require("lazy.core.config")
  if Config.plugins[name] and Config.plugins[name]._.loaded then
    fn(name)
  else
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyLoad",
      callback = function(event)
        if event.data == name then
          fn(name)
          return true
        end
      end,
    })
  end
end

---Properly load file based plugins without blocking the UI
---https://github.com/LazyVim/LazyVim/blob/68ff818a5bb7549f90b05e412b76fe448f605ffb/lua/lazyvim/util/plugin.lua#L60-L125
function M.lazy_file()
  local use_lazy_file = vim.fn.argc(-1) > 0
  local lazy_file_events = { "BufReadPost", "BufNewFile", "BufWritePre" }

  -- Add support for the LazyFile event
  local Event = require("lazy.core.handler.event")

  if use_lazy_file then
    -- We'll handle delayed execution of events ourselves
    Event.mappings.LazyFile = { id = "LazyFile", event = "User", pattern = "LazyFile" }
    Event.mappings["User LazyFile"] = Event.mappings.LazyFile
  else
    -- Don't delay execution of LazyFile events, but let lazy know about the mapping
    Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
    Event.mappings["User LazyFile"] = Event.mappings.LazyFile
    return
  end

  local events = {} ---@type {event: string, buf: number, data?: any}[]

  local done = false
  local function load()
    if #events == 0 or done then
      return
    end
    done = true
    vim.api.nvim_del_augroup_by_name("lazy_file")

    ---@type table<string,string[]>
    local skips = {}
    for _, event in ipairs(events) do
      skips[event.event] = skips[event.event] or Event.get_augroups(event.event)
    end

    vim.api.nvim_exec_autocmds("User", { pattern = "LazyFile", modeline = false })
    for _, event in ipairs(events) do
      if vim.api.nvim_buf_is_valid(event.buf) then
        Event.trigger {
          event = event.event,
          exclude = skips[event.event],
          data = event.data,
          buf = event.buf,
        }
        if vim.bo[event.buf].filetype then
          Event.trigger {
            event = "FileType",
            buf = event.buf,
          }
        end
      end
    end
    vim.api.nvim_exec_autocmds("CursorMoved", { modeline = false })
    events = {}
  end

  vim.api.nvim_create_autocmd(lazy_file_events, {
    group = vim.api.nvim_create_augroup("lazy_file", { clear = true }),
    callback = function(event)
      table.insert(events, event)

      -- schedule wrap so that nested autocmds are executed
      -- and the UI can continue rendering without blocking
      vim.schedule(load)
    end,
  })
end

return M
