{ pkgs, config, ... }:
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

      # shell
      zsh
      starship
      exa
      trash-cli
      zoxide

      # common tools
      fzf
      jq
      bat
      delta
      comma
      htop
      tldr
      rustup
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

  programs.home-manager.enable = true;

  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
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
      pull = {
        rebase=true;
      };
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
