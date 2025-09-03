return {
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local whole_buffer = function(ai_type)
        local start_line, end_line = 1, vim.fn.line("$")
        if ai_type == "i" then
          -- Skip first and last blank lines for `i` textobject
          local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
          -- Do nothing for buffer with all blanks
          if first_nonblank == 0 or last_nonblank == 0 then
            return { from = { line = start_line, col = 1 } }
          end
          start_line, end_line = first_nonblank, last_nonblank
        end

        local to_col = math.max(vim.fn.getline(end_line):len(), 1)
        return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
      end

      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter { -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          },
          f = ai.gen_spec.treesitter { a = "@function.outer", i = "@function.inner" }, -- function
          c = ai.gen_spec.treesitter { a = "@class.outer", i = "@class.inner" }, -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = whole_buffer, -- buffer
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call { name_pattern = "[%w_]" }, -- without dot in function name
        },
      }
    end,
  },

  {
    "echasnovski/mini.files",
    lazy = false,
    keys = {
      {
        "<leader>e",
        function()
          if not require("mini.files").close() then
            require("mini.files").open(vim.api.nvim_buf_get_name(0))
          end
        end,
        desc = "File Explorer: directory of current file",
      },
    },
    opts = {
      use_as_default_explorer = true,
      mappings = {
        synchronize = "<leader>w",
        go_in_plus = "<CR>",
      },
      windows = {
        preview = true,
        width_preview = 35,
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      -- open in split
      local map_split = function(buf_id, lhs, direction)
        vim.keymap.set("n", lhs, function()
          local cur_target = MiniFiles.get_explorer_state().target_window

          -- Make new window and set it as target
          local new_target = vim.api.nvim_win_call(cur_target, function()
            vim.cmd(direction .. " split")
            return vim.api.nvim_get_current_win()
          end)

          MiniFiles.set_target_window(new_target)
          MiniFiles.go_in { close_on_file = true }
        end, { buffer = buf_id, desc = "Split " .. direction })
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          map_split(buf_id, "gs", "belowright horizontal")
          map_split(buf_id, "gv", "belowright vertical")
        end,
      })

      -- toggle hidden files
      local show_hidden_files = true

      local filter_show = function()
        return true
      end

      local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, ".")
      end

      local toggle_dotfiles = function()
        show_hidden_files = not show_hidden_files
        local new_filter = show_hidden_files and filter_show or filter_hide
        vim.notify("Hidden files are " .. (show_hidden_files and "shown" or "hidden"))
        MiniFiles.refresh { content = { filter = new_filter } }
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          local buf_id = args.data.buf_id
          vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
        end,
      })
    end,
  },
}
