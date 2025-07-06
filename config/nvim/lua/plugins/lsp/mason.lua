local M = {
  "williamboman/mason.nvim",
  build = ":MasonUpdate",
}

---@type MasonSettings | { ensure_installed: string[] }
M.opts = {
  PATH = "append",
  ui = {
    border = "rounded",
    height = 0.8,
  },
  ensure_installed = {
    -- lsp
    "clangd",
    "lua-language-server",
    "nil",
    "pyright",
    "ruff",
    "typescript-language-server",

    -- formatter / linter
    "nixpkgs-fmt",
    "selene",
    "shfmt",
    "sqlfluff",
    "stylua",
    "prettier",
  },
}

M.config = function(_, opts)
  require("mason").setup(opts)

  local registry = require("mason-registry")
  registry:on("package:install:success", function()
    vim.defer_fn(function()
      -- trigger FileType event to possibly load this newly installed LSP server
      require("lazy.core.handler.event").trigger {
        event = "FileType",
        buf = vim.api.nvim_get_current_buf(),
      }
    end, 100)
  end)

  registry.refresh(function()
    for _, tool in ipairs(opts.ensure_installed) do
      local p = registry.get_package(tool)
      if not p:is_installed() then
        p:install()
      end
    end
  end)
end

return M
