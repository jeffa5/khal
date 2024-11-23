{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=master";
    pyproject-nix = {
      url = "github:nix-community/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    pyproject-nix,
    self,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    python = pkgs.python3;
    khal = pyproject-nix.lib.project.loadPyproject {
      projectRoot = ./.;
    };
  in {
    packages.${system}.khal = let
      # Returns an attribute set that can be passed to `buildPythonPackage`.
      attrs = khal.renderers.buildPythonPackage {inherit python;} // {version = "0.1.0";};
    in
      # Pass attributes to buildPythonPackage.
      # Here is a good spot to add on any missing or custom attributes.
      python.pkgs.buildPythonPackage attrs;

    devShells.${system}.default = pkgs.mkShell {
      packages = [python];
    };
  };
}
