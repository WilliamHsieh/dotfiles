{ lib, pkgs, config, ... }:
let
  cfg = import ./config.nix;
  dotfilesDir = "${config.home.homeDirectory}/${cfg.repo-path}";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/${path}";
  yamlFormat = pkgs.formats.yaml { };
in
{
  home.packages = with pkgs; [
    gcc
  ];

  xdg.configFile = {
    # https://clangd.llvm.org/config.html
    "clangd/config.yaml".source = yamlFormat.generate "config.yaml" {
      CompileFlags = {
        Add = [ "-Wall" "-Wextra" "-Wshadow" "-std=c++23" ];
        Compiler = "${pkgs.gcc}/bin/g++";
      };
    };
  };

  home.file = {
    ".clang-format".source = link "clangd/.clang-format";
  };
}
