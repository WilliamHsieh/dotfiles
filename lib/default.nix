{ inputs, ... }:
let
  lockfile = builtins.fromJSON (builtins.readFile ../flake.lock);
  inherit (inputs.nixpkgs) lib;
in
{
  stateVersion = "${builtins.elemAt (lib.splitString "-" lockfile.nodes.home-manager.original.ref) 1}";
}
