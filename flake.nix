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

      packages = foreachSystem (system: {
        default = inputs.home-manager.defaultPackage.${system};
      });

      homeConfigurations = mkHome {
        system = "x86_64-linux";
      };

      nixosConfigurations = mkSystem {
        type = "nixos";
      };

      darwinConfigurations = mkSystem {
        type = "darwin";
      };

      # Convenience output that aggregates the outputs for home, nixos, and darwin configurations.
      # Instead of calling `nix build .#nixosConfigurations.{host}.config.system.build.toplevel`,
      # now it's simply `nix build .#top.{host}` or `nix build .#top.{user}`
      top =
        let
          nixtop = genAttrs (builtins.attrNames inputs.self.nixosConfigurations)
            (attr: inputs.self.nixosConfigurations.${attr}.config.system.build.toplevel);
          darwintop = genAttrs (builtins.attrNames inputs.self.darwinConfigurations)
            (attr: inputs.self.darwinConfigurations.${attr}.system);
          hometop = genAttrs (builtins.attrNames inputs.self.homeConfigurations)
            (attr: inputs.self.homeConfigurations.${attr}.activationPackage);
        in
        nixtop // darwintop // hometop;

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
