{ pkgs, config, lib, ... }:
let
  link = path: config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/${path}";
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

      # shell
      starship
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
  };

  programs.home-manager.enable = true;

  programs.nix-index.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = false;
    history.expireDuplicatesFirst = true;
    dotDir = ".config/zsh";
    initExtra = "source ~/.zshrc";
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
    userName = "William Hsieh";
    userEmail = "wh31110@gmail.com";
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
