{ pkgs, config, ... }:
let
  cfg = import ./config.nix;
in
{
  home.packages = with pkgs; [
    glab
  ];

  programs.git = {
    enable = true;
    userName = cfg.name;
    userEmail = cfg.email;
    aliases = {
      undo = "reset HEAD@{1}";
      lg = "log --pretty=format:'%C(red)%h %C(blue)<%an> %C(green)%cs (%cr)  %C(reset)%s %C(auto)%d' --abbrev-commit --graph";
      pushf = "push --force-with-lease";
    };
    delta = {
      enable = true;
      options = {
        true-color = "always";
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
      push = {
        autoSetupRemote = true;
        useForceIfIncludes = true;
      };
      pull.rebase = true;
      rebase = {
        autoStash = true;
        rebaseMerges = true;
        autosquash = true;
        updateRefs = true;
      };
      mergetool.prompt = "false";
    };
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [
      gh-dash
      unstable.gh-copilot
    ];
  };
}
