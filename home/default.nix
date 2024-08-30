{ inputs, pkgs, config, lib, ... }:
let
  cfg = import ./config.nix;
  dotfilesDir = "${config.home.homeDirectory}/${cfg.repo-path}";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/${path}";

  glow-without-completion = pkgs.glow.overrideAttrs
    (oldAttrs: {
      postFixup = ''
        # Remove the completion file
        rm $out/share/zsh/site-functions/_glow
      '';
    });
in
{
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./fzf.nix
    ./git.nix
    ./alacritty.nix
    ./cpp.nix
    inputs.nix-index-database.hmModules.nix-index
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin.flavor = "macchiato";
  catppuccin.enable = true;

  home = {
    inherit (import ../lib { inherit inputs; }) stateVersion;

    username = cfg.user;

    homeDirectory = with pkgs.stdenv;
      if isDarwin then
        "/Users/${cfg.user}"
      else if "${cfg.user}" == "root" then
        "/root"
      else if isLinux then
        "/home/${cfg.user}"
      else "";

    packages = with pkgs; [
      # manage itself
      nix

      # basic tools
      coreutils-full
      util-linux
      file
      findutils
      gawk
      less
      procps
      zlib
      iconv
      wget
      curl

      # useful tools
      fd
      ripgrep
      comma
      htop
      tldr
      dua

      # images
      viu
      # super fast
      feh

      # editor
      unstable.neovim
      unzip
      nodejs
      gnumake

      # shell
      eza
      trash-cli
      bashInteractive

      # parser
      jc
      jq
      jqp

      # language specific
      rustup
      go
      poetry
      python3Full
      nixpkgs-fmt

      # network
      httpie
      socat

      # fun
      sl
      smassh

      # pretty stuff
      glow-without-completion
      csvlens
      litecli

      # misc
      nix-search-cli
      hello-unfree #test unfree packages
      nurl #generate nix fetcher call from repo
      cloc
    ] ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [
      qimgv # export QT_XCB_GL_INTEGRATION=none
      netcat-openbsd # only the bsd version support `-k`
    ]);

    sessionVariables = rec {
      NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
      COLORTERM = "truecolor";
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      EDITOR = "${pkgs.unstable.neovim}/bin/nvim";
      VISUAL = EDITOR;
      MANPAGER = "nvim +Man!";
      LESSUTFCHARDEF = "E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p"; # HACK: https://github.com/sharkdp/bat/issues/2578

      # NOTE: https://github.com/NixOS/nixpkgs/issues/206242
      # LIBRARY_PATH = "${pkgs.iconv}/lib";
      LIBRARY_PATH = "${config.home.profileDirectory}/lib";
    };
  };

  xdg.enable = true;

  xdg.configFile = {
    "nvim".source = link "nvim";
    "home-manager".source = link "..";
    "glow".source = link "glow";
    "zsh/.p10k.zsh".source = link "zsh/.p10k.zsh";
    "vim".source = link "vim";
  };

  nix = {
    package = lib.mkDefault pkgs.nixVersions.latest;
    registry.nixpkgs.flake = inputs.nixpkgs;
    registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
      max-jobs = "auto";
      use-xdg-base-directories = true;
    };
  };

  home.activation = {
    updateNeovimPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH="${config.home.path}/bin:$PATH" run --quiet nvim --headless "+Lazy! restore | qa"
    '';
  };

  programs.home-manager.enable = true;

  programs.dircolors.enable = true;

  programs.bash.enable = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    settings = {
      format = lib.concatStrings [
        "$all"
        "$fill"
        "$time"
        "$line_break"
        "$character"
      ];
      fill = {
        symbol = " ";
      };
      time = {
        disabled = false;
        style = "bold bright-black";
        format = "[\\[$time\\]]($style)";
      };
      container = {
        disabled = true;
      };
      directory = {
        truncation_length = 10;
      };
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.bat = {
    enable = true;
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };

  programs.btop = {
    enable = true;
    settings = {
      vim_keys = true;
    };
  };

  programs.glamour.catppuccin.enable = true;

  programs.man.generateCaches = true;
}
