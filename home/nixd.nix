{
  lib,
  dotfiles,
  ...
}:
let
  toLua =
    val:
    if builtins.isAttrs val then
      "{ "
      + (builtins.concatStringsSep ", " (
        builtins.attrValues (builtins.mapAttrs (k: v: "[${builtins.toJSON k}] = ${toLua v}") val)
      ))
      + " }"
    else if builtins.isList val then
      "{ " + (builtins.concatStringsSep ", " (map toLua val)) + " }"
    else if builtins.isBool val then
      (if val then "true" else "false")
    else if val == null then
      "nil"
    else
      # builtins.toJSON handles escaping and quoting for strings and numbers
      builtins.toJSON val;

  getCurrentFlake = "(builtins.getFlake (toString ./.))";
  nixosExpr = "${getCurrentFlake}.nixosConfigurations.${dotfiles.hostname}.options";
  darwinExpr = "${getCurrentFlake}.darwinConfigurations.${dotfiles.hostname}.options";
  homeExpr = "${getCurrentFlake}.homeConfigurations.${dotfiles.username}.options";
  hmSuboptions = "home-manager.users.type.getSubOptions []";

  configTable = {
    settings = {
      nixd = {
        nixpkgs = {
          expr = "import <nixpkgs> { }";
        };
        formatting = {
          command = [ "nixfmt" ];
        };
        options = {
          nixos = {
            expr = nixosExpr;
          };
          darwin = {
            expr = darwinExpr;
          };
          home_manager = {
            expr =
              if dotfiles.profile == "nixos" then
                "${nixosExpr}.${hmSuboptions}"
              else if dotfiles.profile == "darwin" then
                "${darwinExpr}.${hmSuboptions}"
              else
                "${homeExpr}";
          };
        };
      };
    };
  };

  nixConfig = "return" + (toLua configTable);
in
{
  home.activation.writeNixdConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run echo '${nixConfig}' > "$HOME/.config/nvim/after/lsp/nixd.lua"
  '';
}
