local config = {}

function config.treesitter()
  require("nvim-treesitter.configs").setup {
    sync_install = false,
    ensure_installed = "all",
    ignore_install = { "" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    autopairs = {
      enable = true,
    },
    indent = { enable = true, disable = { "python", "css" } },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
    rainbow = {
      enable = true,
      colors = {
        "Gold",
        "Orchid",
        "DodgerBlue",
        -- "Cornsilk",
        -- "Salmon",
        -- "LawnGreen",
      },
      disable = { "html" },
      extended_mode = false,
      max_file_lines = nil,
    },
    matchup = {
      enable = true,
    },
    playground = {
      enable = true,
    },
  }
end

function config.autotag()
  require('nvim-ts-autotag').setup()
end

function config.autopairs()
  require("nvim-autopairs").setup {
    check_ts = true,
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    fast_wrap = {
      map = "<C-l>",
      chars = { "{", "[", "(", "<", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0, -- Offset from pattern match
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "PmenuSel",
      highlight_grey = "LineNr",
    },
    pairs_map = { -- FIX: not working
      ['<'] = '>',
    }
  }
end

function config.colorizer()
  require("colorizer").setup({ "*" }, {
    RGB = true, -- #RGB hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    names = false, -- "Name" codes like Blue oe blue
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
    css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
    -- Available modes: foreground, background, virtualtext
    mode = "background", -- Set the display mode.)
  })
end

function config.todo()
  require('todo-comments').setup {
    sign_priority = 0
  }
end

function config.illuminate()
  require('illuminate').configure {
    providers = {
      'lsp',
      'treesitter',
    },
    filetypes_denylist = {
      'alpha',
      'NvimTree',
      'toggleterm',
    }
  }
end

function config.indentline()
  require("indent_blankline").setup {
    enable = true,
    char = "▏",
    context_char = "▏",
    show_trailing_blankline_indent = false,
    show_first_indent_level = true,
    use_treesitter = true,
    show_current_context = true,
    buftype_exclude = {
      "terminal",
      "nofile",
    },
    filetype_exclude = {
      "help",
      "dashboard",
      "packer",
      "NvimTree",
      "Trouble",
    },
    context_patterns = {
      "class",
      "return",
      "function",
      "method",
      "^if",
      "^while",
      "^for",
      "^object",
      "^table",
      "block",
      "arguments",
      "if_statement",
      "else_clause",
      "jsx_element",
      "jsx_self_closing_element",
      "try_statement",
      "catch_clause",
      "import_statement",
      "operation_type",
    },
  }
end

function config.twilight()
  require('twilight').setup()
end

function config.zen()
  require("zen-mode").setup {
    plugins = {
      tmux = {
        enabled = true
      }
    }
  }
end

return config
