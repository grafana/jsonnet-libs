{ pkgs ? import <nixpkgs> }:
with pkgs;
mkShell {
  buildInputs = [ hello ];
  shellHook = ''
    # ...
'';
}
