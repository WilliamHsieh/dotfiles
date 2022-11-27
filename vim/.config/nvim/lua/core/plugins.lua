require("packer").startup {
  function(use)
    local module_dir = "/lua/module"
    local tmp = vim.split(vim.fn.globpath(vim.fn.stdpath("config") .. module_dir, '*'), '\n')
    for _, f in ipairs(tmp) do
      local name = string.match(f, module_dir .. '/(.+)')
      local specs = require('module.' .. name)
      for key, plugin in pairs(specs) do
        plugin[1] = key
        use(plugin)
      end
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
    snapshot = "packer_snapshot",
    snapshot_path = vim.fn.stdpath("config"),
    max_jobs = 50,
  }
}
