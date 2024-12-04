{ inputs, ... }:
let
  dotfiles = import ../config;
  lockfile = builtins.fromJSON (builtins.readFile ../flake.lock);
  inherit (inputs.nixpkgs) lib;

  systems = [ "x86_64-linux" "aarch64-darwin" ];
  foreachSystem = lib.genAttrs systems;

  pkgsBySystem = foreachSystem (system:
    # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
    import inputs.nixpkgs {
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
    }
  );
in
{
  inherit foreachSystem pkgsBySystem dotfiles systems;

  stateVersion = "${builtins.elemAt (lib.splitString "-" lockfile.nodes.home-manager.original.ref) 1}";

  mkHome = { system }:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsBySystem.${system};
      extraSpecialArgs = {
        inherit inputs dotfiles;
        isSystemConfig = false;
      };
      modules = [
        ../home
        ./nix.nix
      ];
    };

  mkSystem = { isDarwin }:
    let
      osConfig = ../system/${if isDarwin then "darwin" else "nixos" };
      hmConfig = ../home;

      # NixOS vs nix-darwin functionst
      systemFunc = if isDarwin then inputs.darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
      hmModules = if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;

      hostSystem = if isDarwin then dotfiles.darwin else dotfiles.nixos;
      pkgs = pkgsBySystem.${hostSystem.system};
    in
    {
      ${hostSystem.hostname} = systemFunc
        {
          specialArgs = { inherit inputs pkgs dotfiles; };
          modules = [
            ./nix.nix
            osConfig
            hmModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              # home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = {
                inherit inputs dotfiles;
                isSystemConfig = true;
              };
              home-manager.users.${dotfiles.home.username} = import hmConfig;
            }
          ] ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
            inputs.homebrew.darwinModules.nix-homebrew
          ]);
        };
    };
}
