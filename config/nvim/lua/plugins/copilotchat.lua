---@module "CopilotChat"
local M = {
  "CopilotC-Nvim/CopilotChat.nvim",
  cmd = "CopilotChat",
}

---@type CopilotChat.config
M.opts = {
  model = "claude-3.5-sonnet",
  auto_follow_cursor = false,
  highlight_headers = false,
  separator = "",
  error_header = "> [!ERROR] Error",
  prompts = {
    Explain = {
      prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text. If the context is code, include the relevent code snippet and corresponding line number at the beginning of each praragraph, separated by a line break.",
    },
  },
  mappings = {
    complete = {
      -- otherwise it's conflicting with cmp.nvim
      insert = "<S-Tab>",
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
    "<leader>ca",
    function()
      local actions = require("CopilotChat.actions")
      require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
    end,
    mode = { "n", "v" },
    desc = "CopilotChat - Prompt actions",
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
