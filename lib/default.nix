{ inputs, ... }:
let
  dotfiles = import ../config;
  lockfile = builtins.fromJSON (builtins.readFile ../flake.lock);
  input_name = lockfile.nodes.root.inputs.home-manager;

  inherit (inputs.nixpkgs) lib;

  pkgs =
    # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
    import inputs.nixpkgs {
      inherit (dotfiles) system;
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
    };

  fontPkgs = with pkgs; [
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
  inherit dotfiles pkgs;

  stateVersion = "${builtins.elemAt (lib.splitString "-" lockfile.nodes.${input_name}.original.ref) 1}";

  mkHome = {}: {
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
          home.packages = fontPkgs;
        }
      ];
    };
  };

  mkSystem = { isDarwin }:
    let
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
              fonts.packages = fontPkgs;
            }
          ] ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
            inputs.homebrew.darwinModules.nix-homebrew
          ]);
        };
    };
}
