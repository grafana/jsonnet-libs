let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  default = import ./default.nix;
in pkgs.dockerTools.buildImage {
  name = "haproxy-mixin-build-image";
  created = "now";
  tag = "0.0.1";
  contents = default.buildTools ++ [ pkgs.bash ];
}
