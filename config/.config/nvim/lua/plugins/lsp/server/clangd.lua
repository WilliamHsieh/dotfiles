-- NOTE: https://clangd.llvm.org/guides/system-headers#query-driver
return {
  root_dir = function(...)
    local util = require("lspconfig.util")
    return util.root_pattern("CMakeLists.txt", "Makefile", "configure.ac")(...)
        or util.root_pattern("compile_commands.json", "compile_flags.txt")(...)
        or util.root_pattern(".clang-format", ".clang-tidy")(...)
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
