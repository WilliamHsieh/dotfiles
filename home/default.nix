{ inputs, pkgs, pkgs-unstable, config, lib, ... }:
let
  cfg = import ./config.nix;
  dotfilesDir = "${config.home.homeDirectory}/${cfg.repo-path}";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/${path}";
in
{
  imports = [
    ./zsh.nix
    ./tmux.nix
    inputs.nix-index-database.hmModules.nix-index
  ];

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

    stateVersion = "23.11";

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

      # git
      git
      gh
      glab

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
      glow

      # language specific
      cargo
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

      # misc
      nix-search-cli
      hello-unfree #test unfree packages
    ];
    sessionVariables = rec {
      FZF_COMPLETION_TRIGGER = "__";
      NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
      COLORTERM = "truecolor";
      LANG = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      EDITOR = "${pkgs.neovim}/bin/nvim";
      VISUAL = EDITOR;
      MANPAGER = "nvim +Man!";

      # HACK: https://github.com/sharkdp/bat/issues/2578
      LESSUTFCHARDEF = "E000-F8FF:p,F0000-FFFFD:p,100000-10FFFD:p";
    };
  };

  xdg.enable = true;

  xdg.configFile = {
    "nvim".source = link "nvim";
    "alacritty".source = link "alacritty";
    "starship.toml".source = link "starship/starship.toml";
    "home-manager".source = link "..";
    "zsh/.p10k.zsh".source = link "zsh/.p10k.zsh";
    "clangd/config.yaml".text = ''
      ${lib.removeSuffix "\n" (builtins.readFile ../config/clangd/config.yaml)}
        Compiler: ${pkgs.gcc}/bin/g++
    '';
    "glow/glow.yml".text = /* yaml */ ''
      # style name or JSON path (default "auto")
      style: ${builtins.fetchurl {
        url = "https://github.com/catppuccin/glamour/releases/download/v1.0.0/mocha.json";
        sha256 = "190p7z2hacpd63r7iq2j92h9hj3akfc631zaaxhhrqwbsx19y7ag";
      }}
      # show local files only; no network (TUI-mode only)
      local: false
      # mouse support (TUI-mode only)
      mouse: true
      # use pager to display markdown
      pager: true
      # word-wrap at width
      width: 100
    '';
  };

  home.file = {
    ".vimrc".source = link "vim/.vimrc";
    ".clang-format".source = link "clangd/.clang-format";
  };

  nix = {
    package = lib.mkDefault pkgs.nixUnstable;
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
      PATH="${config.home.path}/bin:$PATH" $DRY_RUN_CMD nvim --headless "+Lazy! restore | qa"
    '';
  };

  programs.home-manager.enable = true;

  programs.dircolors.enable = true;

  programs.bash.enable = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    package = pkgs-unstable.fzf;
    defaultOptions = [
      "--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796"
      "--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6"
      "--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
      "--layout=reverse"
      "--cycle"
      "--bind ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down"
      "--bind 'ctrl-y:execute-silent(echo -n {1..} | ${dotfilesDir}/config/zsh/autoload/yank)+abort'"
    ];
    historyWidgetOptions = [
      "--bind 'ctrl-y:execute-silent(echo -n {2..} | ${dotfilesDir}/config/zsh/autoload/yank)+abort'"
    ];
    changeDirWidgetOptions = [
      "--preview 'eza --color always --tree --level 1 {} | less'"
    ];
    fileWidgetCommand = "fd --follow";
    fileWidgetOptions = [
      "--preview '([[ -f {} ]] && bat --color=always {}) || ([[ -d {} ]] && eza --color always --tree --level 1 {} | less) || echo {} 2> /dev/null | head -200'"
      "--header 'CTRL-H: toggle hidden files'"
      "--bind 'ctrl-h:transform:[[ ! \\$FZF_PROMPT =~ hidden ]]"
      "&& echo \\\"change-prompt(hidden> )+reload(\\$FZF_CTRL_T_COMMAND --hidden --exclude=.git)\\\""
      "|| echo \\\"change-prompt(> )+reload(\\$FZF_CTRL_T_COMMAND)\\\"'"
    ];
  };

  programs.git = {
    enable = true;
    userName = cfg.name;
    userEmail = cfg.email;
    aliases = {
      undo = "reset HEAD@{1}";
      lg = "log --pretty=format:'%C(red)%h %C(blue)<%an> %C(green)%cs (%cr)  %C(reset)%s %C(auto)%d' --abbrev-commit --graph";
    };
    delta = {
      enable = true;
      options = {
        true-color = "always";
        syntax-theme = "base16-256";
        line-numbers = true;
        diff-so-fancy = true;
      };
    };
    ignores = [
      "*.swp"
      ".DS_Store"
    ];
    extraConfig = {
      init.defaultBranch = "master";
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
      };
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase = {
        autoStash = true;
        rebaseMerges = true;
      };
      mergetool.prompt = "false";
    };
  };

  programs.man.generateCaches = true;

  programs.bat = {
    enable = true;
    config = {
      # TODO: https://github.com/catppuccin/bat
      theme = "base16-256";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
    ];
  };
}
