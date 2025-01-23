return {
  { "nvzone/volt", lazy = true },

  {
    "nvzone/menu",
    keys = {
      {
        "<RightMouse>",
        function()
          require("menu.utils").delete_old_menus()

          vim.cmd.exec('"normal! \\<RightMouse>"')

          -- clicked buf
          local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
          local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

          require("menu").open(options, { mouse = true })
        end,
        mode = { "n", "v" },
      },
    },
  },

  {
    "nvzone/showkeys",
    cmd = "ShowkeysToggle",
    opts = {
      maxkeys = 5,
    },
  },

  {
    "nvzone/typr",
    opts = {},
    cmd = { "Typr", "TyprStats" },
  },
}
