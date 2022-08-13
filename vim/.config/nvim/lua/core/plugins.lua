local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.notify("Installing packer...")
  PACKER_BOOTSTRAP = vim.fn.system {
    "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path
  }
  vim.cmd [[packadd packer.nvim]]
elseif IMPATIENT_ERROR then
  vim.notify('impatient is not setup properly')
end

require("packer").startup {
  function(use)
    local modules_dir = vim.fn.stdpath("config") .. "/lua/module"
    local tmp = vim.split(vim.fn.globpath(modules_dir, '*/plugins.lua'), '\n')
    for _, f in ipairs(tmp) do
      local module = string.match(f, 'lua/(.+).lua$'):gsub("/", ".")
      use(require(module))
    end

    if PACKER_BOOTSTRAP then
      require("packer").sync()
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
      threshold = 0, -- integer in milliseconds, plugins which load faster than this won't be shown in profile output
    },
  }
}
