# NOTE: Running Python packages which requires compilation and/or contains libraries precompiled without nix
# https://wiki.nixos.org/wiki/Python

{ pkgs ? import <nixpkgs> { } }:
(
  let
    base = pkgs.appimageTools.defaultFhsEnvArgs;
  in
  pkgs.buildFHSEnv (base // {
    name = "FHS";
    targetPkgs = pkgs: (with pkgs; [
      gcc
      glibc
      zlib
    ]);
    runScript = "zsh";
    extraOutputsToInstall = [ "dev" ];
  })
).env
