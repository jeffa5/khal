{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=master";
  };

  outputs = {
    nixpkgs,
    self,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    python = pkgs.python3.withPackages (ps: [ps.click]);
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = [python];
    };
  };
}
