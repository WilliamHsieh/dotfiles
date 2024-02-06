-- NOTE: https://github.com/oxalica/nil/blob/main/docs/configuration.md
-- NOTE: https://github.com/oxalica/nil/blob/main/dev/nvim-lsp.nix

return {
  settings = {
    ["nil"] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
      nix = {
        flake = {
          autoArchive = false,
        },
      },
    },
  },
}
