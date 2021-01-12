self: super:

{
   podman_compose = super.python3Packages.callPackage ./pkgs/podman-compose {};
}
