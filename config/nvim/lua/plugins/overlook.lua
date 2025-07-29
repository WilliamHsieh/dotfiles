return {
  "williamhsieh/overlook.nvim",

  ---@type OverlookOptions
  opts = {
    on_stack_empty = function()
      require("tint").untint(vim.api.nvim_get_current_win())
    end,
  },

  keys = {
    {
      "<leader>po",
      function()
        require("overlook.api").peek_cursor()
      end,
      desc = "Overlook peek cursor",
    },
    {
      "<leader>pd",
      function()
        require("overlook.api").peek_definition()
      end,
      desc = "Overlook peek definition",
    },
    {
      "<leader>pc",
      function()
        require("overlook.api").close_all()
      end,
      desc = "Overlook close all popups",
    },
    {
      "<leader>pv",
      function()
        require("overlook.api").open_in_vsplit()
      end,
      desc = "Overlook open in vsplit",
    },
    {
      "<leader>ps",
      function()
        require("overlook.api").open_in_split()
      end,
      desc = "Overlook open in split",
    },
    {
      "<leader>pt",
      function()
        require("overlook.api").open_in_tab()
      end,
      desc = "Overlook open in tab",
    },
    {
      "<leader>pq",
      function()
        require("overlook.api").open_in_original_window()
      end,
      desc = "Overlook open in original window",
    },
    {
      "<leader>pu",
      function()
        require("overlook.api").restore_popup()
      end,
      desc = "Overlook restore popup",
    },
    {
      "<leader>pU",
      function()
        require("overlook.api").restore_all_popups()
      end,
      desc = "Overlook restore all popups",
    },
  },
}
