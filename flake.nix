{
  description = "jsonnet-libs shell development tooling";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.jdb.url = "/home/jdb/nixpkgs";

  outputs = { self, nixpkgs, flake-utils, jdb }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ jdb.overlay ];
        };
      in { devShell = import ./shell.nix { inherit pkgs; }; }));
}
