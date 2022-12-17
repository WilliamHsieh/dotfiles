require("packer").startup {
  function(use)
    for path, type in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/module") do
      if type == 'directory' then
        local specs = require('module.' .. path)
        for key, plugin in pairs(specs) do
          plugin[1] = key
          use(plugin)
        end
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
