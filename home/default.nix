{ inputs, pkgs, pkgs-unstable, config, lib, ... }:
let
  cfg = import ./config.nix;
  dotfilesDir = "${config.home.homeDirectory}/${cfg.repo-path}";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/${path}";
in
{
  imports = [
    ./zsh.nix
  ];

  home = rec {
    username = cfg.user;

    homeDirectory = with pkgs.stdenv;
      if isDarwin then
        "/Users/${username}"
      else if "${username}" == "root" then
        "/root"
      else if isLinux then
        "/home/${username}"
      else "";

    stateVersion = "23.11";

    packages = with pkgs; [
      # common tools
      fd
      ripgrep
      comma
      htop
      tldr
      coreutils-full
      gawk

      # images
      viu
      qimgv

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

      # parser
      jc
      jq
      jqp

      # language specific
      cargo
      gcc
      go
      poetry
      python3Full
    ];
    sessionVariables = rec {
      FZF_COMPLETION_TRIGGER = "~~";
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
  };

  home.file = {
    ".vimrc".source = link "vim/.vimrc";
    ".clang-format".source = link "clangd/.clang-format";
  };

  nix = {
    package = pkgs.nixUnstable;
    registry.nixpkgs.flake = inputs.nixpkgs;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };

  home.activation = {
    update-neovim-plugins = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      PATH="${config.home.path}/bin:$PATH" $DRY_RUN_CMD nvim --headless "+Lazy! restore | qa"
    '';
  };

  programs.home-manager.enable = true;

  programs.nix-index.enable = true;

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
    defaultOptions = [
      "--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796"
      "--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6"
      "--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
      "--layout=reverse"
      "--cycle"
      "--bind 'ctrl-y:execute-silent(echo -n {1..} | ${dotfilesDir}/config/zsh/autoload/yank)+abort'"
    ];
    historyWidgetOptions = [
      "--bind 'ctrl-y:execute-silent(echo -n {2..} | ${dotfilesDir}/config/zsh/autoload/yank)+abort'"
    ];
    changeDirWidgetOptions = [
      "--preview 'exa --tree {} | head -200'"
    ];
    fileWidgetOptions = [
      "--preview 'bat --color=always {}'"
    ];
  };

  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    terminal = "xterm-256color";
    shell = "${pkgs.zsh}/bin/zsh";
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = prefix-highlight;
        extraConfig = "source-file ${dotfilesDir}/config/tmux/tmux.conf";
      }
      {
        plugin = pkgs-unstable.tmuxPlugins.fingers;
        extraConfig = "set -g @fingers-key C-f";
      }
      {
        plugin = pkgs-unstable.tmuxPlugins.t-smart-tmux-session-manager;
        extraConfig = "set -g @t-bind 'F4'";
      }
      extrakto
      tmux-fzf
      logging
      resurrect
    ];
  };

  programs.git = {
    enable = true;
    userName = cfg.name;
    userEmail = cfg.email;
    aliases = {
      undo = "reset HEAD@{1}";
    };
    delta = {
      enable = true;
      options = {
        true-color = "always";
        syntax-theme = "base16-256";
        line-numbers = true;
        side-by-side = true;
      };
    };
    ignores = [
      "*.swp"
      ".DS_Store"
    ];
    extraConfig = {
      merge = {
        tool = "vimdiff";
        conflictstyle = "diff3";
      };
      push.autoSetupRemote = true;
      pull.rebase = true;
      rebase.autoStash = true;
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
