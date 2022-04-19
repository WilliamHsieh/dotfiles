local ok, impatient = pcall(require, "impatient")
if not ok then
  vim.notify('impatient is not setup properly')
else
  impatient.enable_profile()
end

require "option"
require "plugin"
require "autocmd"
require "mapping"
