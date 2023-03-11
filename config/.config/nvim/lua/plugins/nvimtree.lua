local M = {
  "nvim-tree/nvim-tree.lua",
  cmd = "NvimTreeToggle",
}

function M.init()
  vim.api.nvim_create_augroup("nvim-tree-loader", {})
  vim.api.nvim_create_autocmd("BufEnter", {
    group = "nvim-tree-loader",
    callback = function()
      local state = vim.loop.fs_stat(vim.fn.expand("%:p"))
      if state and state.type == "directory" then
        require("nvim-tree")
        vim.api.nvim_del_augroup_by_name("nvim-tree-loader")
      end
    end
  })
end

function M.config()
  require('nvim-tree').setup {
    ignore_ft_on_setup = { "alpha" },
    sync_root_with_cwd = true,
    diagnostics = {
      enable = true,
    },
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    view = {
      mappings = {
        custom_only = false,
        list = {
          { key = "?", action = "toggle_help" },
          { key = "l", action = "edit" },
          { key = "h", action = "close_node" },
          { key = "K", action = "toggle_file_info" },
          { key = "y", action = "copy" },
          { key = "<C-k>", action = "" },
        },
      },
    },
    renderer = {
      group_empty = true,
    },
  }
end

return M
