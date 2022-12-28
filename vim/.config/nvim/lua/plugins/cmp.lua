local M = {
  'hrsh7th/nvim-cmp',
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lua",
    "saadparwaiz1/cmp_luasnip",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  }
}

function M.config()
  require("luasnip/loaders/from_vscode").lazy_load()

  local function has_words_before()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
  end

  local function remove_leading_chr(s)
    if string.sub(s, 1, 1) == " " then
      s = s:sub(2)
    end
    return s:gsub('•', '')
  end

  local cmp = require("cmp");
  local luasnip = require("luasnip");
  local mappings = {
    ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
    ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { 'i', 'c' }),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { 'i', 'c' }),
    ["<C-c>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    ["<CR>"] = cmp.mapping.confirm { select = false },
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 'c', 's', }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 'c', 's', }),
  }

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = mappings,
    formatting = {
      format = function(_, vim_item)
        vim_item.kind = string.format("%s %s", require("core.icons").kind[vim_item.kind], vim_item.kind)
        vim_item.abbr = remove_leading_chr(vim_item.abbr)
        return vim_item
      end,
    },
    sources = {
      { name = "nvim_lsp", priority = 100 },
      { name = "nvim_lua", priority = 90 },
      { name = "buffer", priority = 80 },
      { name = "path", priority = 70 },
      { name = "luasnip", priority = 60 },
      { name = "emoji", priority = 50 },
    },
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    window = {
      documentation = {
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      },
    },
    experimental = {
      ghost_text = true,
    },
  }

  cmp.setup.cmdline(':', {
    mapping = mappings,
    sources = {
      { name = "path" },
      { name = "cmdline" },
    },
  })

  cmp.setup.cmdline('/', {
    mapping = mappings,
    sources = {
      { name = "buffer" },
    },
  })

  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end

return M
