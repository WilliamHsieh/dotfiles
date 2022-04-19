local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  vim.notify("no telescope")
  return
end

local actions = require "telescope.actions"
telescope.load_extension "media_files"
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

        ["<PageUp>"] = actions.results_scrolling_up,
        ["<PageDown>"] = actions.results_scrolling_down,

        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

        ["?"] = actions.which_key,
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
  },
  extensions = {
    media_files = {
      -- filetypes whitelist
      -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
      filetypes = { "png", "webp", "jpg", "jpeg" },
      find_cmd = "rg", -- find command (defaults to `fd`)
    },
    -- file_browser = {
    --   -- theme = "ivy",
    --   -- require("telescope.themes").get_dropdown {
    --   --   previewer = false,
    --   --   -- even more opts
    --   -- },
    --   mappings = {
    --     ["i"] = {
    --       -- your custom insert mode mappings
    --     },
    --     ["n"] = {
    --       -- your custom normal mode mappings
    --     },
    --   },
    -- },
    -- ["ui-select"] = {
    --   require("telescope.themes").get_dropdown {
    --     previewer = false,
    --     -- even more opts
    --   },
    -- },
  },
}

-- telescope.load_extension "ui-select"
-- telescope.load_extension "file_browser"
