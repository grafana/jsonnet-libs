{ pkgs ? import <nixpkgs> { } }:
let common = import ./common.nix;
in pkgs.mkShell { buildInputs = common.buildTools ++ common.devTools; }
