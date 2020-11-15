let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  default = import ./default.nix;
in pkgs.mkShell { buildInputs = default.buildTools ++ default.devTools; }
