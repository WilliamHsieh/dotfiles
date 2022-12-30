local M = {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  }
}

function M.config()
  local telescope = require("telescope")
  local actions = require "telescope.actions"
  local icons = require("core.icons")

  telescope.setup {
    defaults = {
      file_ignore_patterns = {
        ".git/",
      },

      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = " ",
      path_display = { "smart" },

      mappings = {
        i = {
          ["<CR>"] = actions.select_default,
          ["<C-c>"] = actions.close,

          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,

          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,

          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,

          ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        },

        n = {
          ["<CR>"] = actions.select_default,
          ["<esc>"] = actions.close,
          ["<C-c>"] = actions.close,
          ["q"] = actions.close,
          ["dd"] = actions.delete_buffer,

          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,

          ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

          ["?"] = actions.which_key,
        },
      },
    },
    pickers = {
      buffers = {
        theme = "dropdown",
        previewer = false,
      },
      find_files = {
        -- find_command = { 'fd', '-L', '--type', 'file', '--type', 'symlink', '--hidden', '--exclude', '.git' }
        find_command = { 'rg', '--ignore', '-L', '--hidden', "--files" }
      },
      live_grep = {
        theme = "ivy",
        glob_pattern = {
          "!.git/"
        },
        additional_args = function()
          return { "--hidden", "-L" }
        end
      },
      colorscheme = {
        enable_preview = true,
      },
      git_status = {
        initial_mode = "normal",
      }
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown()
      },
    },
  }

  telescope.load_extension "fzf"
  telescope.load_extension "projects"
end

return M
