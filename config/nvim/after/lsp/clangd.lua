-- NOTE: https://clangd.llvm.org/guides/system-headers#query-driver
return {
  cmd = {
    "clangd",
    "--background-index",
    "--background-index-priority=low",
    "--clang-tidy",
    -- '--check=cppcoreguidelines-*',
    "--header-insertion=iwyu",
    "--enable-config",
    "--fallback-style=google",
    "--function-arg-placeholders=false",
    "--completion-style=detailed",
    "--query-driver=/nix/store/*gcc-wrapper*/bin/g++",
  },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
}
