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

return config
