require("packer").startup {
  function(use)
    local module_dir = "/lua/module"
    local tmp = vim.split(vim.fn.globpath(vim.fn.stdpath("config") .. module_dir, '*'), '\n')
    for _, f in ipairs(tmp) do
      local name = string.match(f, module_dir .. '/(.+)')
      use(require('module.' .. name))
    end
  end,
  config = {
    display = {
      open_fn = function()
        return require("packer.util").float { border = "rounded" }
      end,
    },
    profile = {
      enable = true,
      threshold = 0,
    },
  }
}
