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
    callbacks = {
      pre_open = function()
        -- Close toggleterm when an external open request is received
        require("toggleterm").toggle(0)
      end,
      post_open = function(bufnr, winnr, ft, is_blocking)
        if not is_blocking then
          -- If it's a normal file, then reopen the terminal, then switch back to the newly opened window
          -- This gives the appearance of the window opening independently of the terminal
          require("toggleterm").toggle(0)
          vim.api.nvim_set_current_win(winnr)
        end
      end,
      block_end = function()
        -- After blocking ends (for a git commit, etc), reopen the terminal
        require("toggleterm").toggle(0)
      end,
    },
  },
}

return {
  toggleterm,
  flatten,
}
