{ lib, pkgs, config, dotfiles, ... }:
let
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles.directory}/config/${path}";
  yamlFormat = pkgs.formats.yaml { };
  clangdConfig = "clangd/config.yaml";
in
{
  home.packages = with pkgs; [
    gcc
    gnumake
    ninja
    mold
  ] ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [
    gdb
  ]);

  xdg.configFile = {
    # https://clangd.llvm.org/config.html
    ${clangdConfig}.source = yamlFormat.generate "config.yaml" {
      CompileFlags = {
        Add = [ "-Wall" "-Wextra" "-Wshadow" "-std=c++23" ];
        Compiler = "${pkgs.gcc}/bin/g++";
      };
    };
  };

  # https://clangd.llvm.org/config#files
  home.activation = lib.optionalAttrs pkgs.stdenv.isDarwin {
    linkClangdConfigPath = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ln -sfn ${config.xdg.configHome}/clangd ${config.home.homeDirectory}/Library/Preferences/clangd
    '';
  };

  home.file = {
    ".clang-format".source = link "clangd/.clang-format";
  };
}
