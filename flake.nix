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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "darwin";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
      lib = inputs.nixpkgs.lib // import ./lib { inherit inputs; };

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

      homeConfigurations = {
        ${dotfiles.home.username} = mkHome {
          inherit (dotfiles.home) system;
        };
        "${dotfiles.home.username}-alt" = mkHome {
          system = builtins.elemAt (builtins.filter (s: s != dotfiles.home.system) systems) 0;
        };
      };

      nixosConfigurations = mkSystem {
        isDarwin = false;
      };

      darwinConfigurations = mkSystem {
        # NOTE: home manager activation is showing following error
        # error: profile '/Users/william/.local/state/nix/profiles/profile' is incompatible with 'nix-env'; please use 'nix profile' instead
        # temporary workaround is to synlink ~/.local/state/nix/profile to ~/.nix-profile
        # ref: https://discourse.nixos.org/t/home-manager-insists-on-using-nix-profile/57708
        isDarwin = true;
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
