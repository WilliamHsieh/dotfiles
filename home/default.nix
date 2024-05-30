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
    inputs.nix-index-database.hmModules.nix-index
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin.flavor = "macchiato";
  catppuccin.enable = true;

  home = {
    username = cfg.user;

    homeDirectory = with pkgs.stdenv;
      if isDarwin then
        "/Users/${cfg.user}"
      else if "${cfg.user}" == "root" then
        "/root"
      else if isLinux then
        "/home/${cfg.user}"
      else "";

    stateVersion = "24.05";

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
      glibc #ldd, iconv, ...
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
      # fast and feature rich
      qimgv # export QT_XCB_GL_INTEGRATION=none
      # super fast
      feh

      # editor
      neovim
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
      gcc
      go
      poetry
      python3Full
      nixpkgs-fmt

      # network
      httpie
      socat
      netcat-openbsd # only the bsd version support `-k`

      # fun
      sl

      # pretty stuff
      glow-without-completion

      # misc
      nix-search-cli
      hello-unfree #test unfree packages
    ];

    sessionVariables = rec {
      NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
      COLORTERM = "truecolor";
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      EDITOR = "${pkgs.neovim}/bin/nvim";
      VISUAL = EDITOR;
      MANPAGER = "nvim +Man!";
      LESSUTFCHARDEF = "E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p"; # HACK: https://github.com/sharkdp/bat/issues/2578
    };
  };

  xdg.enable = true;

  xdg.configFile = {
    "nvim".source = link "nvim";
    "alacritty".source = link "alacritty";
    "home-manager".source = link "..";
    "glow".source = link "glow";
    "zsh/.p10k.zsh".source = link "zsh/.p10k.zsh";
    "clangd/config.yaml".text = ''
      ${lib.removeSuffix "\n" (builtins.readFile ../config/clangd/config.yaml)}
        Compiler: ${pkgs.gcc}/bin/g++
    '';
  };

  home.file = {
    ".vimrc".source = link "vim/.vimrc";
    ".clang-format".source = link "clangd/.clang-format";
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
    update-neovim-plugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH="${config.home.path}/bin:$PATH" run nvim --headless "+Lazy! restore | qa"
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

  programs.glamour.catppuccin.enable = true;

  programs.man.generateCaches = true;
}
