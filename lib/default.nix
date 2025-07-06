{ inputs, ... }:
let
  dotfiles = import ../config;
  lockfile = builtins.fromJSON (builtins.readFile ../flake.lock);
  input_name = lockfile.nodes.root.inputs.home-manager;

  inherit (inputs.nixpkgs) lib;

  systems = [ "x86_64-linux" "aarch64-darwin" ];
  foreachSystem = lib.genAttrs systems;

  pkgsBySystem = foreachSystem (system:
    # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
    import inputs.nixpkgs {
      inherit system;
      overlays = [
        # TODO: this should be local to system specific home-manager module, and loaded conditionally
        inputs.niri.overlays.niri
      ];
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

  fonts = pkgs: with pkgs; [
    maple-mono.Normal-NF-CN-unhinted
    maple-mono.NF-CN-unhinted
  ] ++ (with nerd-fonts; [
    fira-code
    jetbrains-mono
    meslo-lg
    commit-mono
  ]);
in
{
  inherit foreachSystem pkgsBySystem dotfiles systems;

  stateVersion = "${builtins.elemAt (lib.splitString "-" lockfile.nodes.${input_name}.original.ref) 1}";

  mkHome = let pkgs = pkgsBySystem.${dotfiles.system}; in {
    ${dotfiles.username} = inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs dotfiles;
        isSystemConfig = false;
      };
      modules = [
        ../home
        ./nix.nix
        {
          fonts.fontconfig.enable = true;
          home.packages = fonts pkgs;
        }
      ];
    };
  };

  mkSystem = { isDarwin }:
    let
      pkgs = pkgsBySystem.${dotfiles.system};

      # NixOS vs nix-darwin functionst
      systemFunc = if isDarwin then inputs.darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
      hmModules = if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
    in
    {
      ${dotfiles.hostname} = systemFunc
        {
          specialArgs = { inherit inputs pkgs dotfiles; };
          modules = [
            ./nix.nix
            ../system/common
            ../system/${dotfiles.profile}
            hmModules.home-manager
            {
              fonts.packages = fonts pkgs;
            }
          ] ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
            inputs.homebrew.darwinModules.nix-homebrew
          ]);
        };
    };
}
