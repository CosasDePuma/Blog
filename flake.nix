{
  description = "A development shell for my blog!";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs: let systems = [ "aarch64-darwin" "x86_64-linux" ]; in
    inputs.flake-utils.lib.eachSystem systems (system: let pkgs = inputs.nixpkgs.legacyPackages.${system}; in {
      devShells.default = with pkgs; mkShell {
        buildInputs = [ git hugo ];
      };
    });
}
