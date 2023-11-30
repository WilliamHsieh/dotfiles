local M = {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
}

M.opts = {
  messages = {
    view_search = false,
    view_error = "mini",
    view_warn = "mini",
  },
  commands = {
    history = {
      view = "popup",
    },
  },
  lsp = {
    hover = {
      enabled = false,
    },
    signature = {
      enabled = false,
    },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  presets = {
    command_palette = true,       -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = true,            -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true,        -- add a border to hover docs and signature help
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = "",
        any = {
          { find = "%d+L, %d+B written" },
        },
      },
      opts = { skip = true },
    },
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "; after #%d+" },
          { find = "; before #%d+" },
          { find = "Already at %a* change" },
        },
      },
      view = "mini",
    },
  },
}

return M
