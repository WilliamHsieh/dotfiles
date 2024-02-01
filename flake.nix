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
    nixpkgs.url = "github:nixos/nixpkgs/release-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    nur.url = "github:nix-community/nur";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-flake = {
      url = "github:neovim/neovim/v0.9.5?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = (import ./home/config.nix).user;
      hostname = (import ./system/config.nix).host;
      config = { allowUnfree = true; };

      pkgs = import nixpkgs {
        inherit system config;
        overlays = [
          inputs.neovim-flake.overlay
        ];
      };

      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system config;
      };

      inherit (self) outputs;
    in
    {
      packages.${system}.default = home-manager.defaultPackage.${system};

      homeConfigurations = {
        ${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs pkgs-unstable; };

          modules = [
            ./home
            inputs.nix-index-database.hmModules.nix-index
          ];
        };
      };

      nixosConfigurations = {
        ${hostname} = nixpkgs.lib.nixosSystem {
          # specialArgs = { inherit inputs outputs; };
          modules = [
            ./system
            # inputs.nix-index-database.nixosModules.nix-index
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable; };
              home-manager.users.${username} = import ./home;
            }
          ];
        };
      };

      # Convenience output that aggregates the outputs for home, nixos, and darwin configurations.
      # Instead of calling `nix build .#nixosConfigurations.{host}.config.system.build.toplevel`,
      # now it's simply `nix build .#top.{host}` or `nix build .#top.{user}`
      top =
        let
          nixtop = nixpkgs.lib.genAttrs
            (builtins.attrNames inputs.self.nixosConfigurations)
            (attr: inputs.self.nixosConfigurations.${attr}.config.system.build.toplevel);
          hometop = nixpkgs.lib.genAttrs
            (builtins.attrNames inputs.self.homeConfigurations)
            (attr: inputs.self.homeConfigurations.${attr}.activationPackage);
        in
        nixtop // hometop;
    };
}
