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
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; # TODO: remove this later
    };

    homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
      # url = "github:catppuccin/nix/release-25.11";
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
    };

    flatpak = {
      url = "github:gmodena/nix-flatpak/?ref=latest";
    };
  };

  outputs = inputs @ { self, ... }:
    let
      inherit (self.lib) dotfiles;
      inherit (self.lib) pkgs;
      inherit (dotfiles) system;
    in
    {
      lib = inputs.nixpkgs.lib // import ./lib { inherit inputs; };

      packages = {
        ${system} = {
          default =
            if dotfiles.profile == "home" then
              inputs.home-manager.packages.${system}.home-manager
            else if dotfiles.profile == "darwin" then
              inputs.darwin.packages.${system}.darwin-rebuild
            else if dotfiles.profile == "nixos" then
              pkgs.nixos-rebuild
            else if dotfiles.profile == "" then
              builtins.abort "Empty profile type, please run setup.py with `--bootstrap`"
            else
              builtins.abort "Unknown profile type: '${dotfiles.profile}'"
          ;
        };
      };

      homeConfigurations = self.lib.mkHome { };

      nixosConfigurations = self.lib.mkSystem {
        isDarwin = false;
      };

      darwinConfigurations = self.lib.mkSystem {
        # NOTE: home manager activation is showing following error
        # error: profile '/Users/william/.local/state/nix/profiles/profile' is incompatible with 'nix-env'; please use 'nix profile' instead
        # temporary workaround is to synlink ~/.local/state/nix/profile to ~/.nix-profile
        # ref: https://discourse.nixos.org/t/home-manager-insists-on-using-nix-profile/57708
        isDarwin = true;
      };

      checks = {
        pre-commit-check = inputs.git-hooks.lib.${system}.run {
          src = self.lib.cleanSource ./.;
          hooks = {
            # TODO: treefmt, selene, shellcheck
            editorconfig-checker.enable = true;
            nixpkgs-fmt.enable = true;
            stylua = {
              enable = true;
              entry = "${pkgs.stylua}/bin/stylua --config-path ${dotfiles.directory}/config/nvim/stylua.toml";
            };
          };
        };
      };

      devShells = {
        default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = self.checks.${system}.pre-commit-check.enabledPackages;
        };
      };
    };
}
