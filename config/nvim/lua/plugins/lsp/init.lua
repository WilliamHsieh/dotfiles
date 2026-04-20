local M = {
  "neovim/nvim-lspconfig",
  cmd = { "Mason", "LspInfo" },
  event = "LazyFile",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "ray-x/lsp_signature.nvim",
    "smjonas/inc-rename.nvim",

    require("plugins.lsp.mason"),
    require("plugins.lsp.null-ls"),
  },
}

function M.config()
  local cb = function(ev)
    local bufnr = ev.buf
    local function opts(desc)
      return { buffer = bufnr, desc = desc }
    end
    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, opts("signature_help"))
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover doc"))
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("go to definition"))
    vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, opts("go to type definition"))
    vim.keymap.set("n", "gr", "<cmd>FzfLua lsp_references<cr>", opts("go to references"))
    vim.keymap.set("n", "<leader>lr", ":IncRename ", opts("Rename"))
    vim.keymap.set("n", "<leader>lR", function()
      return ":" .. require("inc_rename").config.cmd_name .. " " .. vim.fn.expand("<cword>")
    end, { buffer = bufnr, expr = true, desc = "Rename (with cword)" })

    vim.keymap.set("n", "<leader>lh", function()
      local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
      vim.notify("LSP inlay hint: " .. (not enabled and "on" or "off"))
    end, opts("toggle inlay hints"))
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = cb,
  })

  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  vim.lsp.config("*", {
    capabilities = capabilities,
  })

  require("mason-lspconfig").setup()

  -- enable all lsp by default
  vim.schedule(function()
    local servers = vim.fs.dir(vim.fs.joinpath(vim.fn.stdpath("config"), "after", "lsp"))
    for name, _ in servers do
      local server_name = name:gsub("%.lua$", "")
      vim.lsp.enable(server_name)
    end
  end)

  require("plugins.lsp.utils").setup_auto_detach()

  -- settings
  local signs = { Error = "", Info = "󰋼", Hint = "󰌵", Warn = "" }
  for name, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
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
      source = "if_many",
    },
  }
end

return M
