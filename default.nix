{ pkgs ?  import (fetchTarball https://github.com/NixOS/nixpkgs/archive/20.09.tar.gz) {},
   ...  }:


let
  packages = rec {
    podman_compose = pkgs.python3Packages.callPackage ./pkgs/podman-compose {};

    inherit pkgs; # similar to `pkgs = pkgs;` This lets callers use the nixpkgs version defined in this file.
  };
in {
  environment.systemPackages = with packages; [ podman_compose ];
}
