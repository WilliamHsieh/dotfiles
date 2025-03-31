local toggleterm = {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  opts = {
    open_mapping = [[<c-\>]],
    size = 20,
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = false,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    auto_scroll = false,
    persist_mode = true,
    on_stdout = function(term, _, data, _)
      if term:is_open() then return end
      for _, s in pairs(data) do
        local pos, _ = string.find(s, "❯")
        if pos and s:sub(-1) ~= ' ' then
          local res = s:sub(pos - 3, pos - 2) == "32" and {"Success", "info"} or {"Failed", "error"}
          vim.notify("Job finished: " .. res[1] .. "!", res[2], { title = term.name })
        end
      end
    end,
    float_opts = {
      border = "curved",
      winblend = 0,
    },
    highlights = {
      FloatBorder = {
        link = 'FloatBorder'
      },
    },
  },
}

local flatten = {
  "willothy/flatten.nvim",
  priority = 1010,
  opts = {
    hooks = {
      pre_open = function()
        -- Close toggleterm when an external open request is received
        require("toggleterm").toggle(0)
      end,
      block_end = function()
        -- After blocking ends (for a git commit, etc), reopen the terminal
        require("toggleterm").toggle(0)
      end,
    },
    window = {
      open = "vsplit",
    },
  },
}

return {
  toggleterm,
  flatten,
}
