{ inputs, ... }:
with inputs.nixpkgs.lib;
let
  lockfile = builtins.fromJSON (builtins.readFile ../flake.lock);
  inherit (inputs.nixpkgs) lib;

  dotfiles = import ../config;

  foreachSystem = genAttrs [ "x86_64-linux" "aarch64-darwin" ];

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

  exposeArgs = {
    config._module.args = {
      inherit dotfiles;
    };
  };
in
{
  stateVersion = "${builtins.elemAt (lib.splitString "-" lockfile.nodes.home-manager.original.ref) 1}";

  mkHome = { system }:
    {
      ${dotfiles.home.username} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsBySystem.${system};
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ../home
          exposeArgs
        ];
      };
    };

  mkSystem = { type }:
    let
      # TODO: assert type is either "darwin" or "nixos"
      isDarwin = type == "darwin";
      osConfig = ../system/${if isDarwin then "darwin" else "nixos" };
      userHMConfig = ../home;

      # NixOS vs nix-darwin functionst
      systemFunc = if isDarwin then inputs.darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
      osModules = if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;

      hostSystem = if isDarwin then dotfiles.darwin else dotfiles.nixos;
      pkgs = pkgsBySystem.${hostSystem.system};
    in
    {
      ${hostSystem.hostname} = systemFunc
        {
          specialArgs = { inherit inputs pkgs dotfiles; };
          modules = [
            osConfig
            exposeArgs
            osModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              # home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs dotfiles; };
              home-manager.users.${dotfiles.home.username} = import userHMConfig;
            }
          ];
        };
    };
}
