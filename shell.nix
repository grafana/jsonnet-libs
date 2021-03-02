{ pkgs ? import <nixpkgs> }:
with pkgs;
mkShell {
  buildInputs = [ docsonnet go-jsonnet jsonnet-bundler ];
  shellHook = ''
    # ...
  '';
}
