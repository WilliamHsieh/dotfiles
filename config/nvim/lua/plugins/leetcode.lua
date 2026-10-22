return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  cmd = "Leet",
  dependencies = {
    {
      "3rd/image.nvim",
      build = false,
      opts = {
        backend = "kitty",
        processor = "magick_cli",
      },
    },
  },
  opts = {
    keys = {
      quit = "q",
      reset_testcases = "R",
    },
    hooks = {
      ["enter"] = {
        function()
          require("copilot.command").disable()
          vim.g.copilot_disabled = true
          vim.g.autoformat = true
          vim.keymap.set("n", "<leader>cc", "<cmd>Leet run<cr>", { desc = "Leetcode run testcase" })
          vim.keymap.set("n", "<leader>cp", "<cmd>Leet submit<cr>", { desc = "Leetcode submit" })
          vim.keymap.set("n", [[<c-\>]], "<cmd>Leet console<cr>", { desc = "Leetcode console" })
        end,
      },
    },
    image_support = true,
  },
}
