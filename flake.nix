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
      url = "github:neovim/neovim/v0.9.4?dir=contrib";
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
      username = (import ./config.nix).user;

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
        overlays = [
          inputs.neovim-flake.overlay
        ];
      };

      homeDirectory = with pkgs.stdenv;
        if isDarwin then
          "/Users/${username}"
        else if username == "root" then
          "/root"
        else if isLinux then
          "/home/${username}"
        else "";

      inherit (self) outputs;
    in
    {
      packages.${system}.default = home-manager.defaultPackage.${system};

      homeConfigurations = {
        ${username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs outputs; };

          modules = [
            ./home.nix
            inputs.nix-index-database.hmModules.nix-index
            {
              home = {
                inherit username homeDirectory;
                stateVersion = "23.11";
              };
            }
          ];
        };
      };
    };
}
