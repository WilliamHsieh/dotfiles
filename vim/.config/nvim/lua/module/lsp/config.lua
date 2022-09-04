local config = {}

function config.lsp()
  require("mason").setup()
  require("mason-lspconfig").setup()
  require("mason-lspconfig").setup_handlers {
    function(server_name)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

      local opts = {
        on_attach = function(client)
          if client.resolved_capabilities.document_highlight then
            require("illuminate").on_attach(client)
          end
        end,
        capabilities = capabilities,
      }

      local have_config, server_opts = pcall(require, "module.lsp.server." .. server_name)
      if have_config then
        opts = vim.tbl_deep_extend("force", server_opts, opts)
      end

      require("lspconfig")[server_name].setup(opts)
    end
  }

  -- settings
  local icons = require "icons"
  local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo", text = icons.diagnostics.Information },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  vim.diagnostic.config {
    virtual_text = false,
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }
end

function config.outline()
  local icons = require "icons"
  vim.g.symbols_outline = {
    highlight_hovered_item = true,
    show_guides = true,
    auto_preview = false,
    position = "right",
    relative_width = true,
    width = 25,
    show_numbers = false,
    show_relative_numbers = false,
    show_symbol_details = true,
    keymaps = { -- These keymaps can be a string or a table for multiple keys
      close = { "<Esc>", "q" },
      goto_location = "<Cr>",
      focus_location = "o",
      hover_symbol = "<C-space>",
      toggle_preview = "K",
      rename_symbol = "r",
      code_actions = "a",
    },
    lsp_blacklist = {},
    symbol_blacklist = {},
    symbols = {
      File = { icon = icons.documents.File, hl = "CmpItemKindFile" },
      Module = { icon = icons.kind.Module, hl = "CmpItemKindModule" },
      Namespace = { icon = icons.kind.Module, hl = "CmpItemKindModule" },
      Package = { icon = icons.kind.Module, hl = "CmpItemKindModule" },
      Class = { icon = icons.kind.Class, hl = "CmpItemKindClass" },
      Method = { icon = icons.kind.Method, hl = "CmpItemKindMethod" },
      Property = { icon = icons.kind.Property, hl = "CmpItemKindProperty" },
      Field = { icon = icons.kind.Field, hl = "CmpItemKindField" },
      Constructor = { icon = icons.kind.Constructor, hl = "CmpItemKindConstructor" },
      Enum = { icon = icons.kind.Enum, hl = "CmpItemKindEnum" },
      Interface = { icon = icons.kind.Interface, hl = "CmpItemKindInterface" },
      Function = { icon = icons.kind.Function, hl = "CmpItemKindFunction" },
      Variable = { icon = icons.kind.Variable, hl = "CmpItemKindVariable" },
      Constant = { icon = icons.kind.Constant, hl = "CmpItemKindConstant" },
      String = { icon = icons.type.String, hl = "TSString" },
      Number = { icon = icons.type.Number, hl = "TSNumber" },
      Boolean = { icon = icons.type.Boolean, hl = "TSBoolean" },
      Array = { icon = icons.type.Array, hl = "TSKeyword" },
      Object = { icon = icons.type.Object, hl = "TSKeyword" },
      Key = { icon = icons.kind.Keyword, hl = "CmpItemKeyword" },
      Null = { icon = "NULL", hl = "TSKeyword" },
      EnumMember = { icon = icons.kind.EnumMember, hl = "CmpItemKindEnumMember" },
      Struct = { icon = icons.kind.Struct, hl = "CmpItemKindStruct" },
      Event = { icon = icons.kind.Event, hl = "CmpItemKindEvent" },
      Operator = { icon = icons.kind.Operator, hl = "CmpItemKindOperator" },
      TypeParameter = { icon = icons.kind.TypeParameter, hl = "CmpItemKindTypeParameter" },
    },
  }
end

function config.signature()
  require('lsp_signature').setup {
    doc_lines = 0,
    floating_window = false,
  }
end

function config.lspsaga()
  require('lspsaga').init_lsp_saga {
    finder_action_keys = {
      open = "<CR>",
      vsplit = "v",
      split = "s",
      quit = "q",
      scroll_down = "<C-d>",
      scroll_up = "<C-u>",
    },
  }
end

return config
