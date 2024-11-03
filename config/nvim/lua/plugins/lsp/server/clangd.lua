-- NOTE: https://clangd.llvm.org/guides/system-headers#query-driver
return {
  root_dir = function(...)
    local util = require("lspconfig.util")

    local clang_format_not_home = function(...)
      local path = util.root_pattern(".clang-format")(...)
      if path and path ~= vim.uv.os_homedir() then
        return path
      end
    end

    return util.root_pattern("CMakeLists.txt", "Makefile", "configure.ac")(...)
      or util.root_pattern("compile_commands.json", "compile_flags.txt", ".clang-tidy")(...)
      or clang_format_not_home(...)
      or util.find_git_ancestor(...)
  end,
  capabilities = {
    offsetEncoding = { "utf-16" },
  },
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    -- '--clang-tidy-checks=*',
    '--header-insertion=iwyu',
    '--enable-config',
    '--fallback-style=google',
    '--function-arg-placeholders=false',
    '--completion-style=detailed',
    '--query-driver=/nix/store/*gcc-wrapper*/bin/g++',
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}
