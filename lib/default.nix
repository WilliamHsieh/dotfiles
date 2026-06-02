{ inputs, ... }:
let
  dotfiles = import ../config;

  nixpkgsOverlays = [
    # TODO: this should be local to system specific home-manager module, and loaded conditionally
    inputs.niri.overlays.niri
  ];

  nixpkgsConfig = {
    allowUnfree = true;
    allowUnfreePredicate = (_: true);
    packageOverrides = pkgs: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (dotfiles) system;
        inherit (pkgs) config;
      };
    };
  };

  pkgs =
    # https://github.com/nix-community/home-manager/issues/2942#issuecomment-1378627909
    import inputs.nixpkgs {
      inherit (dotfiles) system;
      overlays = nixpkgsOverlays;
      config = nixpkgsConfig;
    };

  fontPkgs =
    with pkgs;
    [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      maple-mono.Normal-NF-CN-unhinted
      maple-mono.NF-CN-unhinted
    ]
    ++ (with nerd-fonts; [
      fira-code
      jetbrains-mono
      meslo-lg
      commit-mono
    ]);
in
{
  inherit dotfiles pkgs;

  homeConfigurations = {
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

  systemConfigurations =
    let
      isDarwin = pkgs.stdenv.isDarwin;

      # NixOS vs nix-darwin functionst
      systemFunc = if isDarwin then inputs.darwin.lib.darwinSystem else inputs.nixpkgs.lib.nixosSystem;
      hmModules =
        if isDarwin then inputs.home-manager.darwinModules else inputs.home-manager.nixosModules;
    in
    {
      ${dotfiles.hostname} = systemFunc {
        specialArgs = { inherit inputs dotfiles; };
        modules = [
          ./nix.nix
          ../system/common
          ../system/${dotfiles.profile}
          hmModules.home-manager
          {
            fonts.packages = fontPkgs;
            nixpkgs.overlays = nixpkgsOverlays;
            nixpkgs.config = nixpkgsConfig;
          }
        ]
        ++ (pkgs.lib.optionals pkgs.stdenv.isDarwin [
          inputs.homebrew.darwinModules.nix-homebrew
        ]);
      };
    };
}
