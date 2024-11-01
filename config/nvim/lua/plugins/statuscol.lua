local M = {
  "luukvbaal/statuscol.nvim",
  dependencies = "nvim-ufo",
  event = { "VeryLazy", "LazyFile" },
}

function M.config()
  local builtin = require("statuscol.builtin")
  require("statuscol").setup {
    setopt = true,
    relculright = true,
    segments = {
      {
        sign = { namespace = { "gitsigns" }, maxwidth = 1, auto = true, wrap = true },
        click = "v:lua.ScSa",
      },
      {
        text = { builtin.lnumfunc, " " },
        condition = { true, builtin.not_empty },
        click = "v:lua.ScLa",
      },
      {
        text = { builtin.foldfunc },
        click = "v:lua.ScFa",
      },
    },
  }
end

return M
