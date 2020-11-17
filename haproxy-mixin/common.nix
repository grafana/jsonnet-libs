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
  # devTools are packages specifically for development environments.
  devTools = [ pkgs.docker pkgs.docker-compose ];
  # buildTools are packages needed for dev and CI builds.
  buildTools = [
    pkgs.bash
    pkgs.coreutils
    pkgs.cue
    pkgs.drone-cli
    pkgs.git
    pkgs.gnumake
    pkgs.gnutar
    pkgs.jsonnet
    pkgs.jsonnet-bundler
    pkgs.mixtool
  ];
}
