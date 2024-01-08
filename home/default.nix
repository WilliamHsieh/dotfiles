{ inputs, pkgs, config, lib, ... }:
let
  cfg = import ./config.nix;
  dotfilesDir = "${config.home.homeDirectory}/${cfg.repo-path}";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/${path}";
in
{
  imports = [
    ./zsh.nix
  ];

  home = {
    packages = with pkgs; [
      # common tools
      fd
      ripgrep
      comma
      htop
      tldr
      coreutils-full

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
    sessionVariables = {
      FZF_COMPLETION_TRIGGER = "~~";
      NIX_PATH = "nixpkgs=${inputs.nixpkgs}";
      COLORTERM = "truecolor";
    };
  };

  xdg.enable = true;

  xdg.configFile = {
    "nvim".source = link ".config/nvim";
    "alacritty".source = link ".config/alacritty";
    "starship.toml".source = link ".config/starship.toml";
    "home-manager".source = link "..";
    "clangd/config.yaml".text = ''
      ${lib.removeSuffix "\n" (builtins.readFile ../config/.config/clangd/config.yaml)}
        Compiler: ${pkgs.gcc}/bin/g++
    '';
  };

  home.file = {
    ".vimrc".source = link ".vimrc";
    ".zshrc".source = link ".zshrc";
    ".tmux.conf".source = link ".tmux.conf";
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
    install-zinit = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ZINIT_HOME="${config.xdg.dataHome}/zinit/zinit.git"
      if ! [ -d "$ZINIT_HOME" ]; then
        $DRY_RUN_CMD ${pkgs.git}/bin/git clone $VERBOSE_ARG https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
      fi
    '';

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
        extraConfig = "source-file ~/.tmux.conf";
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
