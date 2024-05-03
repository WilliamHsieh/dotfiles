{ pkgs, config, ... }:
let
  cfg = import ./config.nix;
  dotfilesPath = "${config.home.homeDirectory}/${cfg.repo-path}";

  filePreview = "bat --color=always {}";
  dirPreview = "eza --color always --tree --level 1 {} | less";

  yankField = field:
    "ctrl-y:execute-silent(echo -n {${toString field}..} | ${dotfilesPath}/config/zsh/autoload/yank)+abort";
in
{
  home.sessionVariables = {
    FZF_COMPLETION_TRIGGER = "__";
  };

  programs.fzf = {
    enable = true;
    package = pkgs.unstable.fzf;
    defaultOptions = [
      "--layout=reverse"
      "--cycle"
      "--bind 'ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down'"
      "--bind '${yankField 1}'"
    ];
    historyWidgetOptions = [
      "--bind '${yankField 2}'"
    ];
    changeDirWidgetOptions = [
      "--preview '${dirPreview}'"
    ];
    fileWidgetCommand = "fd --follow";
    fileWidgetOptions = [
      "--preview '([[ -f {} ]] && ${filePreview}) || ([[ -d {} ]] && ${dirPreview}) || echo {} 2> /dev/null | head -200'"
      "--header 'CTRL-H: toggle hidden files'"
      "--bind 'ctrl-h:transform:[[ ! \\$FZF_PROMPT =~ hidden ]]"
      "&& echo \\\"change-prompt(hidden> )+reload(\\$FZF_CTRL_T_COMMAND --hidden --exclude=.git)\\\""
      "|| echo \\\"change-prompt(> )+reload(\\$FZF_CTRL_T_COMMAND)\\\"'"
    ];
  };
}
