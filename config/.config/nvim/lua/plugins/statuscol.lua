local M = {
  "luukvbaal/statuscol.nvim",
  event = "VeryLazy",
}

function M.config()
  local builtin = require "statuscol.builtin"
  require("statuscol").setup {
    setopt = true,
    relculright = true,
    segments = {
      {
        sign = { name = { "GitSigns" }, maxwidth = 1, auto = true, wrap = true },
        click = "v:lua.ScSa",
      },
      {
        sign = { name = { "Diagnostic" }, maxwidth = 1, auto = true },
        click = "v:lua.ScSa"
      },
      { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
      {
        text = { builtin.lnumfunc, " " },
        condition = { true, builtin.not_empty },
        click = "v:lua.ScLa",
      },
      {
        sign = { name = { "Dap" }, maxwidth = 1, auto = true },
        click = "v:lua.ScSa",
      },
      {
        sign = { name = { ".*" }, maxwidth = 2, colwidth = 1, auto = true, wrap = true },
        click = "v:lua.ScSa"
      },
    },
  }
end

return M
