{
  description = "flake to provide an overlay and devShell for type2sql Python package";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    nix-utils.url = "github:padhia/nix-utils";
    nix-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, nixpkgs, nix-utils, flake-utils}:
  let
    inherit (nix-utils.lib) pyDevShell;

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
    in {
      devShells.default = pyDevShell {
        inherit pkgs;
        name = "type2sql";
        pyVer = "312";
      };
    };

  in {
    inherit overlays;
    inherit (flake-utils.lib.eachDefaultSystem targetSystem) devShells;
  };
}
