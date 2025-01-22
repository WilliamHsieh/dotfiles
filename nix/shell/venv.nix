{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    python3
    python3Packages.venvShellHook
    pyright
  ];
  venvDir = "./.venv";

  # https://nixos.org/manual/nixpkgs/stable/#python
  # Run this command, only after creating the virtual environment
  postVenvCreation = ''
    exec echo "use nix" >> .envrc
  '';

  # Now we can execute any commands within the virtual environment.
  # This is optional and can be left out to run pip manually.
  postShellHook =
    let
      ld_library_path = pkgs.lib.makeLibraryPath [
        pkgs.pythonManylinuxPackages.manylinux2014Package
      ];
    in
      /* bash */ ''
      unset SOURCE_DATE_EPOCH
      export LD_LIBRARY_PATH=${ld_library_path}

      # allow pip to install wheels
      unset SOURCE_DATE_EPOCH
      # pip install -r requirements.txt
    '';

  # NOTE: zsh-nix-shell is messing with env variable, run the following command for venv to behave properly
  # source ${venvDir}/bin/activate
  # https://github.com/chisui/zsh-nix-shell/issues/19
  # NOTE: use direnv solve this currently, or find out where PATH is set
}

# NOTE: the poetry route: requirements -> poetry.toml -> poetry2nix
# https://github.com/python-poetry/poetry/issues/663#issuecomment-471060279
# https://github.com/nix-community/poetry2nix
# (I like this approach more, it's more nix way, but also more problematic)
