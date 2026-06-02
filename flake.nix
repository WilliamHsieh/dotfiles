{
  description = "Procrastinating has never felt this productive";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://williamhsieh.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "williamhsieh.cachix.org-1:t3jW1IF+bHXN4Ce7ZZe9pLSjRB6D1gwz0EgGdgYxHNg="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs"; # TODO: remove this later
    };

    homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    catppuccin = {
      url = "github:catppuccin/nix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
  };

  outputs =
    inputs@{ self, ... }:
    let
      inherit (inputs.nixpkgs) lib;
      inherit (import ./lib { inherit inputs; })
        dotfiles
        pkgs
        homeConfigurations
        systemConfigurations
        ;
      inherit (dotfiles) system profile;

      byProfile = {
        home = {
          package = inputs.home-manager.packages.${system}.home-manager;
          configurations = { inherit homeConfigurations; };
        };
        darwin = {
          package = inputs.darwin.packages.${system}.darwin-rebuild;
          configurations = {
            darwinConfigurations = systemConfigurations;
          };
        };
        nixos = {
          package = pkgs.nixos-rebuild;
          configurations = {
            nixosConfigurations = systemConfigurations;
          };
        };
      };
    in
    {
      packages.${system}.default =
        byProfile.${profile}.package or (
          if profile == "" then
            abort "Empty profile type, please run setup.py with `--bootstrap`"
          else
            abort "Unknown profile type: '${profile}'"
        );

      checks = {
        ${system}.pre-commit-check = inputs.git-hooks.lib.${system}.run {
          src = lib.cleanSource ./.;
          hooks = {
            # TODO: treefmt, selene, shellcheck
            editorconfig-checker.enable = true;
            nixfmt.enable = true;
            stylua = {
              enable = true;
              entry = "${pkgs.stylua}/bin/stylua --config-path ${dotfiles.directory}/config/nvim/stylua.toml";
            };
          };
        };
      };

      devShells = {
        ${system}.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        };
      };
    }
    // (byProfile.${profile}.configurations or { });
}
