local config = {}

function config.hop()
  require('hop').setup {
    -- keys = 'asdghklqwertyuiopzxcvbnmfj' -- default
    keys = 'awefjio;sdghklqrtyupvbn'
  }
end

function config.session_manager()
  require('session_manager').setup {
    autoload_mode = require('session_manager.config').AutoloadMode.Disabled,
  }
end

function config.vimtex()
  vim.g.vimtex_view_method = 'skim'
  vim.g.vimtex_view_skim_sync = 1
  vim.g.vimtex_view_skim_activate = 1
  vim.g.vimtex_quickfix_open_on_warning = 0
  vim.g.vimtex_toc_config = {
    indent_levels = 1,
    show_help = 0,
    layers = {
      'content',
    }
  }
  -- nvim --headless -c "VimtexInverseSearch %line '%file'"
end

return config
