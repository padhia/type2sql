{
  description = "flake to provide an overlay and devShell for type2sql Python package";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, nixpkgs, flake-utils}:
  let
    overlays.default = final: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (py-final: py-prev: {
          type2sql = py-final.callPackage ./type2sql.nix {};
        })
      ];
    };

    targetSystem = system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ self.overlays.default ];
      };

      pyPkgs = pkgs.python312Packages;

    in {
      devShells.default = pkgs.mkShell {
        name = "type2sql";
        venvDir = "./.venv";
        buildInputs = with pyPkgs; [
          pkgs.ruff
          pkgs.uv
          python
          venvShellHook
          pytest
        ];
      };
    };

  in {
    inherit overlays;
    inherit (flake-utils.lib.eachDefaultSystem targetSystem) devShells;
  };
}
