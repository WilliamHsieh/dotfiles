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
}
