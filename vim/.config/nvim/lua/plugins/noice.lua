local M = {
  "folke/noice.nvim",
  priority = 100,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
}

-- FIX: not showing (first?) echo messages: https://github.com/folke/noice.nvim/issues/71

function M.config()
  require("noice").setup {
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
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
    routes = {
      {
        -- don't show written messages
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
      -- XXX: noice: filter.find support string[]
      {
        -- don't show message on change `u` or `<C-R>`
        filter = {
          event = "msg_show",
          kind = "",
          find = "; %a* #%d",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "Already at %a* change",
        },
        opts = { skip = true },
      },
    },
  }
end

return M
