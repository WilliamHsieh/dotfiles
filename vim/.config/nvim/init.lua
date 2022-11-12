local impatient_avail, impatient = pcall(require, "impatient")
if impatient_avail then
  impatient.enable_profile()
end

require "core.setting"
require "core.autocmd"
require "core.mapping"

local packer_path = vim.fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
  vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", packer_path }
  vim.cmd.packadd("packer.nvim")
  require("core.plugins")
  require("packer").sync()

  vim.api.nvim_create_autocmd("User", {
    pattern = "PackerComplete",
    group = "config_group",
    callback = function()
      vim.cmd("bw | Bdelete")
      vim.cmd("Alpha")
      require("packer").loader("nvim-treesitter")
    end,
  })
elseif not impatient_avail then
  vim.notify('impatient is not setup properly')
end
