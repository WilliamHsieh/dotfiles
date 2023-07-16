local M = {
  "neovim/nvim-lspconfig",
  cmd = { "Mason", "LspInfo" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
    "ray-x/lsp_signature.nvim",
    "RRethy/vim-illuminate",
    "smjonas/inc-rename.nvim",
  },
}

function M.config()
  require("neodev").setup {
    library = {
      plugins = false,
    }
  }
  require("mason").setup {
    ui = {
      border = "rounded",
      height = 0.8,
    }
  }
  require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "clangd", "pyright" }
  }

  local on_attach = function(client, bufnr)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover doc" })
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "go to definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "go to declaration" })
    vim.keymap.set("n", "<leader>lr", ":IncRename ", { buffer = bufnr, desc = "Rename" })
  end

  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
  }

  require("mason-lspconfig").setup_handlers {
    function(lsp_name)
      local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
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
      border = "rounded",
      source = "always",
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
