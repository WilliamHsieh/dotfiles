{ pkgs, config, lib, ... }:
let
  cfg = import ./config.nix;
  config-path = "${config.home.homeDirectory}/${cfg.repo-path}/config";
  link = path: config.lib.file.mkOutOfStoreSymlink "${config-path}/${path}";
in {
  home = {
    packages = with pkgs; [
      # essential
      git

      # editor
      neovim
      ripgrep
      fd
      unzip
      nodejs
      gnumake

      # shell
      exa
      trash-cli

      # common tools
      fzf
      jq
      bat
      delta
      comma
      htop
      tldr
      rustup
      gcc
    ];
  };

  xdg.configFile = {
    "nvim".source = link ".config/nvim";
    "alacritty".source = link ".config/alacritty";
    "starship.toml".source = link ".config/starship.toml";
    "clangd".source = link ".config/clangd";
    "home-manager".source = link "..";
  };

  home.file = {
    ".vimrc".source = link ".vimrc";
    ".zshrc".source = link ".zshrc";
    ".tmux.conf".source = link ".tmux.conf";
  };

  nix = {
    package = pkgs.nixUnstable;
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

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    history.expireDuplicatesFirst = true;
    dotDir = ".config/zsh";
    initExtraFirst = ''
      # p10k instant prompt
      echo ""
      if [[ -r "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-''$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # source nix profile
      if [[ -r "''$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
        source "''$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
    '';
    initExtra = "source ~/.zshrc";
  };

  programs.bash.enable = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
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
    delta = {
      enable = true;
      options = {
        true-color = "always";
        syntax-theme = "base16-256";
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
  };
}
