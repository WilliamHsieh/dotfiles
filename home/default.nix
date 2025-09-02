{ inputs, pkgs, config, lib, dotfiles, ... }:
let
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles.directory}/config/${path}";

  glow-without-completion = pkgs.glow.overrideAttrs
    (oldAttrs: {
      # glow with completion can't complete file path
      # solution: remove the completion file
      postFixup = ''
        rm $out/share/zsh/site-functions/_glow
      '';
    });

  # NOTE: impure
  # isWSL = lib.strings.hasInfix "Microsoft" (builtins.readFile /proc/version);
in
{
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./fzf.nix
    ./git.nix
    ./alacritty.nix
    ./cpp.nix
    inputs.nix-index-database.homeModules.nix-index
    inputs.catppuccin.homeModules.catppuccin
  ];

  home = {
    inherit (import ../lib { inherit inputs; }) stateVersion;

    inherit (dotfiles) username;

    homeDirectory = with pkgs.stdenv;
      if isDarwin then
        "/Users/${dotfiles.username}"
      else if "${dotfiles.username}" == "root" then
        "/root"
      else if isLinux then
        "/home/${dotfiles.username}"
      else "";

    packages = with pkgs; [
      # manage itself
      nix

      # lib
      zlib
      iconv

      # basic tools
      coreutils-full
      util-linux
      xdg-utils
      gnugrep
      file
      findutils
      gawk
      less
      procps
      wget
      curl

      # useful tools
      fd
      ripgrep
      comma
      tldr
      dua
      just
      mprocs

      # images
      viu
      # super fast
      feh

      # editor
      unstable.neovim
      unzip
      nodejs

      # shell
      eza
      trash-cli
      bashInteractive

      # parser
      jc
      jq
      jqp
      sq

      # language specific
      rustup
      go
      uv
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
      nix-tree

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
      COLORTERM = "truecolor";
      # FIX: should i change both of these to C.UTF-8?
      # feels like it's causing p10k to not display correctly
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      EDITOR = "nvim";
      VISUAL = EDITOR;
      MANPAGER = "nvim +Man!";
      LESSUTFCHARDEF = "E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p"; # HACK: https://github.com/sharkdp/bat/issues/2578

      # NOTE: https://github.com/NixOS/nixpkgs/issues/206242
      # LIBRARY_PATH = "${pkgs.iconv}/lib";
      LIBRARY_PATH = "${config.home.profileDirectory}/lib";
    };

    activation = {
      updateNeovimPlugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        PATH="${config.home.path}/bin:$PATH" run --quiet nvim --headless "+Lazy! restore | qa"
      '';

      linkHomeManagerPath = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        ln -sfn ${config.home-files} ${config.home.homeDirectory}/.local/share/home-files
      '';
    };
  };

  xdg.enable = true;

  xdg.configFile = {
    "nvim".source = link "nvim";
    "home-manager".source = link "..";
    "glow".source = link "glow";
    "vim".source = link "vim";
    "niri".source = link "niri";
    "waybar".source = link "waybar";
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";

    glamour.enable = true;
    fuzzel.accent = "lavender";
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

  programs.htop = {
    enable = true;
    settings = {
      cpu_count_from_one = 0;
      screen_tabs = 1;
      delay = 10;
      highlight_base_name = 1;
      highlight_megabytes = 1;
      highlight_threads = 1;
    } // (with config.lib.htop; leftMeters [
      (bar "LeftCPUs2")
      (bar "Memory")
      (bar "Swap")
    ]) // (with config.lib.htop; rightMeters [
      (bar "RightCPUs2")
      (text "Tasks")
      (text "LoadAverage")
      (text "DiskIO")
      (text "Uptime")
    ]);
  };

  programs.fuzzel = {
    enable = pkgs.stdenv.isLinux;
    settings = {
      main = {
        terminal = "${pkgs.alacritty}/bin/alacritty";
        layer = "overlay";
      };
      border = {
        width = 2;
      };
      # TODO: how to overwrite the default config?
      colors = {
        background = "#1E1E2Eff";
      };
    };
  };

  # for fast-syntax-highlighting
  programs.man.generateCaches = true;

  home.pointerCursor = {
    enable = pkgs.stdenv.isLinux;
    package = pkgs.xcursor-pro;
    name = "XCursor-Pro-Dark";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  services.home-manager.autoExpire = {
    enable = pkgs.stdenv.isLinux;
    store = {
      cleanup = true;
      options = "--delete-older-than 30d";
    };
  };

  services.mako = {
    enable = pkgs.stdenv.isLinux;
    settings = {
      default-timeout = 10000;
    };
  };

  services.pueue = {
    enable = pkgs.stdenv.isLinux;
    settings = {
      daemon = {
        default_parallel_tasks = 1;
      };
    };
  };
}
