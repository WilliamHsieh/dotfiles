{ pkgs, dotfiles, ... }:
{
  home.packages = with pkgs; [
    glab
  ];

  # FIX: zsh completion still not working
  # consider overwriting scss completion or prioritize user nix profile over root profile
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      true-color = "always";
      line-numbers = true;
      diff-so-fancy = true;
      # NOTE: toggle side-by-side view: `export DELTA_FEATURES="side-by-side"`
      # ref: https://github.com/dandavison/delta/issues/359#issuecomment-751447333
    };
  };

  programs.git = {
    enable = true;
    ignores = [
      "*.swp"
      ".DS_Store"
    ];
    settings = {
      safe = {
        directory = [ "/marketdata" ];
      };
      user = {
        name = dotfiles.fullname;
        email = dotfiles.email;
      };
      alias = {
        undo = "reset HEAD@{1}";
        lg = "log --pretty=format:'%C(red)%h %C(blue)<%an> %C(green)%cs (%cr)  %C(reset)%s %C(auto)%d' --abbrev-commit --graph";
        pushf = "push --force-with-lease";
        review = /* bash */ ''!f() { nvim +"DiffviewFileHistory --range=''${1:-master}.."; }; f'';
        unstage = "reset HEAD --";
      };
      init.defaultBranch = "master";
      core = {
        whitespace = "error";
      };
      url = {
        "git@github.com" = {
          insteadOf = "gh";
        };
        "git@gitlab.com" = {
          insteadOf = "gl";
        };
      };
      merge = {
        tool = "diffview";
      };
      push = {
        default = "current";
        followTags = true;
        autoSetupRemote = true;
        useForceIfIncludes = true;
      };
      pull = {
        default = "current";
        rebase = true;
      };
      rebase = {
        autoStash = true;
        rebaseMerges = true;
        autosquash = true;
        updateRefs = true;
        missingCommitsCheck = "warn";
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
      gh-copilot
    ];
  };
}
