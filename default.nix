{
  ...
}:

with pkgs;

let
  packages = rec {
    podman_compose = python3Packages.callPackage ./pkgs/podman-compose {};

    #inherit pkgs; # similar to `pkgs = pkgs;` This lets callers use the nixpkgs version defined in this file.
  };
in
  packages
