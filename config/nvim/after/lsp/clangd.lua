-- NOTE: https://clangd.llvm.org/guides/system-headers#query-driver
return {
  root_dir = function(bufnr, on_dir)
    local root = vim.fs.root(bufnr, { ".clang-format" })
    if root and root ~= vim.env.HOME then
      on_dir(root)
      return
    end

    root = vim.fs.root(bufnr, {
      {
        ".clangd",
        ".clang-tidy",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
      },
      {
        ".git",
      },
    })
    if root then
      on_dir(root)
    end
  end,
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
