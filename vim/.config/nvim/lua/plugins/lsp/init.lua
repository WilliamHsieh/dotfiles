local M = {
  "williamboman/mason-lspconfig.nvim",
  event = "BufReadPre",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "folke/neodev.nvim",
  },
}

function M.config()
  require("neodev").setup()
  require("mason").setup {
    ui = {
      border = "rounded",
    }
  }
  require("mason-lspconfig").setup {
    ensure_installed = { "sumneko_lua", "clangd", "pyright" }
  }
  require("mason-lspconfig").setup_handlers {
    function(lsp_name)
      local opts = {
        on_attach = function(client, bufnr)
          local opt = { buffer = bufnr }
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opt)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opt)
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opt)
          require("illuminate").on_attach(client)
        end,
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      }

      local have_config, lsp_config = pcall(require, "plugins.lsp.server." .. lsp_name)
      if have_config then
        opts = vim.tbl_deep_extend("force", lsp_config, opts)
      end

      require("lspconfig")[lsp_name].setup(opts)
    end
  }

  -- settings
  local icons = require "core.icons"
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

  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = 'rounded' }
  )

  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = 'rounded' }
  )

  require('lspconfig.ui.windows').default_options.border = 'rounded'
end

return M
