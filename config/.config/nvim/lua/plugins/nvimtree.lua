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
        -- FIX: this is opening wrong directory
        require("lazy").load { plugins = { "nvim-tree.lua" } }
        vim.cmd.NvimTreeToggle()
        vim.api.nvim_del_augroup_by_name("nvim-tree-loader")
      end
    end
  })
end

M.opts = {
  sync_root_with_cwd = true,
  diagnostics = {
    enable = true,
  },
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  renderer = {
    group_empty = true,
  },
  on_attach = function(bufnr)
    local api = require('nvim-tree.api')
    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end
    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.del('n', '<C-k>', { buffer = bufnr })
    vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts('Close Directory'))
    vim.keymap.set('n', 'l', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'K', api.node.show_info_popup, opts('Info'))
    vim.keymap.set('n', 'y', api.fs.copy.node, opts('Copy'))
  end,
}

return M
