{ pkgs, config, dotfiles, ... }:
{
  home.packages = with pkgs; [
    glab
  ];

  programs.git = {
    enable = true;
    userName = dotfiles.home.fullname;
    userEmail = dotfiles.home.email;
    aliases = {
      undo = "reset HEAD@{1}";
      lg = "log --pretty=format:'%C(red)%h %C(blue)<%an> %C(green)%cs (%cr)  %C(reset)%s %C(auto)%d' --abbrev-commit --graph";
      pushf = "push --force-with-lease";
      review = /* bash */ ''!f() { nvim +"DiffviewFileHistory --range=''${1:-master}.."; }; f'';
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
        tool = "diffview";
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
      mergetool = {
        prompt = "false";
        keepBackup = "false";
        diffview = {
          cmd = "nvim +DiffviewOpen $MERGE";
        };
      };
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
