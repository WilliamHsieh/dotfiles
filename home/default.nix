{ inputs, pkgs, config, lib, dotfiles, ... }:
let
  symlinkDotfiles = path: config.lib.file.mkOutOfStoreSymlink "${dotfiles.directory}/${path}";

  # NOTE: impure
  # isWSL = lib.strings.hasInfix "Microsoft" (builtins.readFile /proc/version);
in
{
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./fzf.nix
    ./skim.nix
    ./git.nix
    ./alacritty.nix
    ./ghostty.nix
    ./desktop.nix
    ./cpp.nix
    inputs.nix-index-database.homeModules.nix-index
    inputs.catppuccin.homeModules.catppuccin
  ] ++ (lib.optionals (dotfiles.profile == "nixos") [
    ../system/nixos/home.nix
  ]);

  home = {
    stateVersion = "25.05";

    preferXdgDirectories = true;

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
      openssl
      pkg-config

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
      gzip # for zcat

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
      tree-sitter
      unzip
      nodejs

      # shell
      eza
      trash-cli
      bashInteractive

      # audio
      # yt-dlp # temporarily disabled: curl-cffi build failure in nixpkgs
      ffmpeg

      # parser
      jc
      jq
      jqp
      sq
      lnav # log viewer

      # language specific
      rustup
      go
      bun
      uv
      poetry
      python315
      nixpkgs-fmt
      nixfmt-rfc-style

      # network
      httpie
      socat

      # fun
      sl
      smassh

      # pretty stuff
      csvlens
      litecli
      nix-tree

      navi
      newsboat

      # misc
      nix-search-cli
      hello-unfree #test unfree packages
      nurl #generate nix fetcher call from repo
      cloc
    ] ++ (pkgs.lib.optionals pkgs.stdenv.isLinux [
      qimgv # export QT_XCB_GL_INTEGRATION=none
      netcat-openbsd # only the bsd version support `-k`
    ]);

    sessionPath = [
      "$HOME/.uv/bin"
    ];

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
      DOTFILES_DIR = "${dotfiles.directory}";
      NAVI_PATH = "${dotfiles.directory}/config/navi";
      UV_TOOL_BIN_DIR = "${config.home.homeDirectory}/.uv/bin";

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

  home.file."tools".source = symlinkDotfiles "config/tools";
  home.file.".claude/commands".source = symlinkDotfiles ".claude/commands";

  xdg.configFile = {
    "dotfiles".source = symlinkDotfiles ".";
    "nvim".source = symlinkDotfiles "config/nvim";
    "vim".source = symlinkDotfiles "config/vim";
    "navi".source = symlinkDotfiles "config/navi";
    "newsboat/config".source = symlinkDotfiles "config/newsboat/config";
    "newsboat/themes/catppuccin".source = "${config.catppuccin.sources.newsboat}/dark";
    "Vencord/themes/catppuccin.css".text = ''
      @import url("https://catppuccin.github.io/discord/dist/catppuccin-macchiato-sky.theme.css");
    '';
    "environment.d/fcitx5.conf" = lib.mkIf pkgs.stdenv.isLinux {
      text = ''
        GTK_IM_MODULE=fcitx
        QT_IM_MODULE=fcitx
        XMODIFIERS=@im=fcitx
      '';
    };
  };

  catppuccin = {
    enable = true;
    flavor = "macchiato";
    accent = "sky";

    mako.enable = dotfiles.profile == "nixos";
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

  # for fast-syntax-highlighting
  programs.man.generateCaches = true;

  systemd.user.startServices = "sd-switch";

  services.home-manager.autoExpire = {
    enable = pkgs.stdenv.isLinux;
    store = {
      cleanup = true;
      options = "--delete-older-than 30d";
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
