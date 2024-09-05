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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
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
  };

  outputs = inputs @ { self, ... }:
    with self.lib;
    {
      lib = import ./lib { inherit inputs; } // inputs.nixpkgs.lib;

      packages = foreachSystem (system:
        {
          default = self.packages.${system}.home-manager;
          inherit (inputs.home-manager.packages.${system}) home-manager;
        } // (optionalAttrs (system == dotfiles.nixos.system) {
          inherit (pkgsBySystem.${system}) nixos-rebuild;
        }) // (optionalAttrs (system == dotfiles.darwin.system) {
          inherit (inputs.darwin.packages.${system}) darwin-rebuild;
        })
      );

      homeConfigurations = mkHome {
        system = "x86_64-linux";
      };

      nixosConfigurations = mkSystem {
        type = "nixos";
      };

      darwinConfigurations = mkSystem {
        type = "darwin";
      };

      checks = foreachSystem (system: {
        pre-commit-check = inputs.git-hooks.lib.${system}.run {
          src = cleanSource ./.;
          hooks = {
            # TODO: treefmt, selene, shellcheck
            editorconfig-checker.enable = true;
            nixpkgs-fmt.enable = true;
            stylua = {
              enable = true;
              entry = "${pkgsBySystem.${system}.stylua}/bin/stylua --config-path ./config/nvim/stylua.toml";
            };
          };
        };
      });

      devShells = foreachSystem (system: {
        default = pkgsBySystem.${system}.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        };
      });
    };
}
