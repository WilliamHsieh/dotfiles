local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  vim.notify("no telescope")
  return
end

local actions = require "telescope.actions"
local icons = require("icons")

telescope.setup {
  defaults = {

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
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
        -- previewer = false,
      },
    },
  },
}

telescope.load_extension("ui-select")
telescope.load_extension('projects')
