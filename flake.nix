{
  description = "Brave Origin Beta — privacy-oriented browser (beta channel, Origin variant)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in
    {
      packages = forAllSystems (system: {
        brave-origin-beta = (pkgsFor system).callPackage ./package.nix { };
        default = self.packages.${system}.brave-origin-beta;
      });

      overlays.default = _final: prev: {
        brave-origin-beta = prev.callPackage ./package.nix { };
      };
    };
}
