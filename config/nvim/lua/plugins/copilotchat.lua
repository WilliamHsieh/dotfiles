---@module "CopilotChat"
local M = {
  "CopilotC-Nvim/CopilotChat.nvim",
  cmd = "CopilotChat",
  build = function()
    vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
  end,
}

---@type CopilotChat.config
M.opts = {
  prompts = {
    Explain = {
      prompt =
      "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text. If the context is code, include the relevent code snippet and corresponding line number at the beginning of each praragraph, separated by a line break.",
    },
  },
}

M.keys = {
  {
    "K",
    "<cmd>CopilotChatExplain<cr>",
    mode = "v",
    desc = "CopilotChat - Explain code",
  },
  {
    "<leader>ch",
    "<cmd>CopilotChat<cr>",
    desc = "CopilotChat - open chat history",
  },
  {
    "<leader>cd",
    "<cmd>CopilotChatFixDiagnostic<cr>",
    desc = "CopilotChat - Fix diagnostic",
  },
  {
    "<leader>co",
    function()
      local is_visual = vim.fn.mode():lower():find("v")
      local select = require("CopilotChat.select")

      local input = vim.fn.input("Quick Chat: ")
      if input ~= "" then
        require("CopilotChat").ask(input, {
          selection = is_visual and select.visual or select.buffer,
        })
      end
    end,
    mode = { "n", "v" },
    desc = "CopilotChat - Quick chat",
  },
}

return M
