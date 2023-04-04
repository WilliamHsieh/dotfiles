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

      # terminal multiplexer
      tmux
      fzf

      # common tools
      direnv
      jq
      bat
      delta
      comma
      htop
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

  programs.home-manager.enable = true;

  programs.direnv.enable = true;

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
