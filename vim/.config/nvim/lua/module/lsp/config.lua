local config = {}

function config.lsp()
  require("mason").setup {
    ui = {
      border = "rounded",
    }
  }
  require("mason-lspconfig").setup {
    ensure_installed = { "sumneko_lua", "clangd", "pyright" }
  }
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
  require("symbols-outline").setup()
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
