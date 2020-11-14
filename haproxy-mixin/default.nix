let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs {
    overlays = [
      (self: super:
        let inherit (super) callPackage;
        in {
          jsonnet-bundler = callPackage ./nix/jsonnet-bundler.nix { };
          mixtool = callPackage ./nix/mixtool.nix { };
        })
    ];
  };
in {
  buildTools = [
    pkgs.docker-compose
    pkgs.drone-cli
    pkgs.jsonnet-bundler
    pkgs.gnumake
    pkgs.mixtool
    pkgs.gocode
    pkgs.golangci-lint
    pkgs.gotools
    pkgs.go_1_14
    pkgs.go-tools
  ];
}
