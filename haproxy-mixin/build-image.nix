let
  common = import ./common.nix;
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
in pkgs.dockerTools.buildImage {
  name = "jdbgrafana/haproxy-mixin-build-image";
  created = "now";
  tag = "0.0.3";
  contents = common.buildTools;
}
