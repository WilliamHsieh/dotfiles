# NOTE: Running Python packages which requires compilation and/or contains libraries precompiled without nix
# https://wiki.nixos.org/wiki/Python

{ pkgs ? import <nixpkgs> { } }:
let
  fhs = import ./fhs.nix { inherit pkgs; };
in
pkgs.mkShell {
  nativeBuildInputs = fhs.nativeBuildInputs;
  shellHook = /* bash */ ''
    [[ -d .venv ]] || python -m venv .venv
    printf "Activating virtual environment..."
    source .venv/bin/activate
  '' + "${fhs.shellHook}";
}
