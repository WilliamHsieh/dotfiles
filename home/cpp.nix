{ lib, pkgs, config, dotfiles, ... }:
let
  dotDir = "${config.home.homeDirectory}/${dotfiles.home.dotDir}";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotDir}/config/${path}";
  yamlFormat = pkgs.formats.yaml { };
  clangdConfig = "clangd/config.yaml";
in
{
  home.packages = with pkgs; [
    gcc
  ];

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
      ln -sfn ${config.xdg.configHome}/${clangdConfig} ${config.home.homeDirectory}/Library/Preferences/${clangdConfig}
    '';
  };

  home.file = {
    ".clang-format".source = link "clangd/.clang-format";
  };
}
