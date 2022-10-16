local config = {}

function config.telescope()
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

          ["<PageUp>"] = actions.results_scrolling_up,
          ["<PageDown>"] = actions.results_scrolling_down,

          ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

          ["?"] = actions.which_key,
        },
      },
    },
    pickers = {
      find_files = {
        find_command = {
          'fd',
          '--type',
          'file',
          '--type',
          'symlink',
          '--hidden',
          '--exclude',
          '.git',
        }
      },
      live_grep = {
        glob_pattern = {
          "!.git/"
        },
        additional_args = function()
          return {"--hidden"}
        end
      },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown()
      },
    },
  }

  telescope.load_extension("ui-select")
end

function config.project()
  require("project_nvim").setup {
    detection_methods = { "pattern" },
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "CMakeLists.txt" },
  }

  require("telescope").load_extension "projects"
end

function config.bookmark()
  local icons = require "core.icons"
  vim.g.bookmark_sign = icons.ui.BookMark
  vim.g.bookmark_annotation_sign = icons.ui.Comment
  vim.g.bookmark_no_default_key_mappings = 1

  vim.g.bookmark_center = 1
  vim.g.bookmark_location_list = 0
  vim.g.bookmark_disable_ctrlp = 1
end

function config.gitsigns()
  require("gitsigns").setup {
    signs = {
      add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    },
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
      delay = 0,
      ignore_whitespace = false,
    },
    current_line_blame_formatter_opts = {
      relative_time = false,
    },
    preview_config = {
      border = "rounded",
    },
  }
end

return config
