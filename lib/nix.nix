{ inputs, pkgs, lib, ... }:
let
  # https://github.com/Misterio77/nix-config/blob/8bb813869ea740fd7bcca1a033ecb53cc2bf77de/hosts/common/global/nix.nix#L7
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  nix = {
    package = lib.mkDefault pkgs.nixVersions.latest;
    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
      max-jobs = "auto";
      use-xdg-base-directories = true;
      auto-optimise-store = !pkgs.stdenv.isDarwin;

      # add these to global /etc/nix/nix.conf when using home manager, and restart nix-daemon by `systemctl restart nix-daemon`
      # nix-daemon doesn't watch the nix.conf file: https://github.com/NixOS/nix/issues/8939
      trusted-users = [
        "root"
        "@wheel"
      ];
      extra-substituters = lib.mkAfter [
        "https://nix-community.cachix.org"
        "https://williamhsieh.cachix.org"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "williamhsieh.cachix.org-1:t3jW1IF+bHXN4Ce7ZZe9pLSjRB6D1gwz0EgGdgYxHNg="
      ];
    };
  };
}
