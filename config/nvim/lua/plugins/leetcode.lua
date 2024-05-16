return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  cmd = "Leet",
  opts = {
    keys = {
      reset_testcases = "R",
    },
    injector = {
      ["cpp"] = {
        before = {
          "#include <bits/stdc++.h>",
          "using namespace std;",
        },
      },
    },
    hooks = {
      ["enter"] = {
        function()
          vim.g.lsp_formatting = true
          vim.keymap.set("n", "<leader>cc", "<cmd>Leet run<cr>", { desc = "Leetcode run testcase" })
          vim.keymap.set("n", "<leader>cp", "<cmd>Leet submit<cr>", { desc = "Leetcode submit" })
          vim.keymap.set("n", [[<c-\>]], "<cmd>Leet console<cr>", { desc = "Leetcode console" })
        end,
      },
    },
  },
}
