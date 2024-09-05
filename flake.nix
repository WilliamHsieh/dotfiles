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

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    with self.lib;
    let
      system = "x86_64-linux";
      foreachSystem = genAttrs [ "x86_64-linux" "aarch64-darwin" ];

      username = (import ./home/config.nix).user;

      # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          packageOverrides = pkgs: {
            unstable = import inputs.nixpkgs-unstable {
              inherit (pkgs) system config;
            };
          };
        };
      };

      inherit (self) outputs;
    in
    {
      lib = import ./lib { inherit inputs; } // inputs.nixpkgs.lib;

      # packages.${system}.default = home-manager.defaultPackage.${system};

      homeConfigurations = {
        ${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs; };

          modules = [
            ./home
          ];
        };
      };

      nixosConfigurations = lib.mkSystem {
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
          nixtop = nixpkgs.lib.genAttrs
            (builtins.attrNames inputs.self.nixosConfigurations)
            (attr: inputs.self.nixosConfigurations.${attr}.config.system.build.toplevel);
          darwintop = nixpkgs.lib.genAttrs
            (builtins.attrNames inputs.self.darwinConfigurations)
            (attr: inputs.self.darwinConfigurations.${attr}.system);
          hometop = nixpkgs.lib.genAttrs
            (builtins.attrNames inputs.self.homeConfigurations)
            (attr: inputs.self.homeConfigurations.${attr}.activationPackage);
        in
        nixtop // darwintop // hometop;

      # checks.${system}.pre-commit-check = inputs.git-hooks.lib.${system}.run {
      #   src = pkgs.lib.cleanSource ./.;
      #
      #   hooks = {
      #     # TODO: treefmt, selene, shellcheck
      #     editorconfig-checker.enable = true;
      #     nixpkgs-fmt.enable = true;
      #     stylua = {
      #       enable = true;
      #       entry = "${pkgs.stylua}/bin/stylua --config-path ./config/nvim/stylua.toml";
      #     };
      #   };
      # };
      #
      # devShells.${system}.default = pkgs.mkShell {
      #   inherit (self.checks.${system}.pre-commit-check) shellHook;
      #   buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
      # };
    };
}
